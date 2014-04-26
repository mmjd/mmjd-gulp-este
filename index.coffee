gulp = require 'gulp'

_ = require 'lodash'
closureCompiler = require 'gulp-closure-compiler'
closureDeps = require 'gulp-closure-deps'
concat = require 'gulp-concat'
cond = require 'gulp-cond'
eventStream = require 'event-stream'
filter = require 'gulp-filter'
fs = require 'fs'
gutil = require 'gulp-util'
minifyCss = require 'gulp-minify-css'
path = require 'path'
plumber = require 'gulp-plumber'
rename = require 'gulp-rename'
size = require 'gulp-size'

module.exports = class GulpEste

  ###*
    @param {string} dirname __dirname or something else.
    @param {boolean} production Production flag.
    @param {string=} depsPrefix Optional deps prefix.
  ###
  constructor: (@dirname, @production, @depsPrefix) ->
    @globals = Object.keys global

  changedFilePath: null
  globals: null
  liveReloadServer: null

  ###*
    @param {(string|Array.<string>)} paths
    @return {Stream} Node.js Stream.
  ###
  stylus: (paths) ->
    stylus = require 'gulp-stylus'

    # Don't emit error on build, only for watch mode.
    # It prevents false positive builds.
    watchMode = !!@changedFilePath
    paths = [paths] if not Array.isArray paths

    streams = paths.map (path) =>
      gulp.src path, base: '.'
        .pipe plumber (error) ->
          # This ensures watching is not interrupted on error.
          this.emit 'end' if watchMode
        .pipe stylus set: ['include css'], errors: true
        .pipe gulp.dest '.'
        .pipe rename (path) ->
          path.dirname = path.dirname.replace '/css', '/build'
          return
        .pipe cond @production, minifyCss()
        .pipe gulp.dest '.'
    eventStream.merge streams...

  ###*
    @param {(string|Array.<string>)} paths
    @return {Stream} Node.js Stream.
  ###
  coffee: (paths) ->
    coffee = require 'gulp-coffee'
    coffee2closure = require 'gulp-coffee2closure'

    paths = [paths] if not Array.isArray paths
    gulp.src @changedFilePath ? paths, base: '.'
      .pipe plumber()
      .pipe coffee bare: true
      .on 'error', (err) -> gutil.log err.message
      .pipe coffee2closure()
      .pipe gulp.dest '.'

  ###*
    @param {(string|Array.<string>)} paths
    @return {Stream} Node.js Stream.
  ###
  jsx: (paths) ->
    jsx = require 'gulp-react'

    paths = [paths] if not Array.isArray paths
    gulp.src @changedFilePath ? paths, base: '.'
      .pipe plumber()
      .pipe jsx harmony: true
      .on 'error', (err) -> gutil.log err.message
      .pipe gulp.dest '.'

  ###*
    Alias for jsx method.
    @deprecated Use jsx instead.
  ###
  react: ->
    @jsx.apply @, arguments

  ###*
    @param {(string|Array.<string>)} paths
    @return {Stream} Node.js Stream.
  ###
  deps: (paths) ->
    paths = [paths] if not Array.isArray paths
    gulp.src paths
      .pipe closureDeps fileName: 'deps0.js', prefix: @depsPrefix
      .pipe gulp.dest 'tmp'

  ###*
    @param {string} baseJsDir
    @param {(string|Array.<string>)} paths
    @return {Stream} Node.js Stream.
  ###
  unitTest: (baseJsDir, paths) ->
    paths = [paths] if not Array.isArray paths
    nodejsPath = path.join baseJsDir, 'bootstrap/nodejs'
    changedFilePath = @changedFilePath

    if changedFilePath
      # Ensure changedFilePath is _test.js file.
      if !/_test\.js$/.test changedFilePath
        changedFilePath = changedFilePath.replace '.js', '_test.js'
      return if not fs.existsSync changedFilePath

    chai = require 'chai'
    jsdom = require 'jsdom'
    sinon = require 'sinon'
    react = require 'react'
    requireUncache = require 'require-uncache'
    mocha = require 'gulp-mocha'

    # Clean global variables created during test. For instance: goog and este.
    Object.keys(global).forEach (key) =>
      return if @globals.indexOf(key) > -1
      delete global[key]

    # Global aliases for tests.
    global.assert = chai.assert;
    global.sinon = sinon

    # Mock browser, add React.
    doc = jsdom.jsdom()
    global.window = doc.parentWindow
    global.document = doc.parentWindow.document
    global.navigator = doc.parentWindow.navigator
    global.React = react

    # Server-side Google Closure, refreshed for each test.
    requireUncache path.resolve nodejsPath
    requireUncache path.resolve 'tmp/deps0.js'
    require path.resolve nodejsPath
    require path.resolve 'tmp/deps0.js'

    # Auto-require Closure dependencies.
    autoRequire = (file) =>
      jsPath = file.path.replace '_test.js', '.js'
      return false if not fs.existsSync jsPath
      relativePath = path.join @depsPrefix, jsPath.replace @dirname, ''
      namespaces = goog.dependencies_.pathToNames[relativePath];
      namespace = Object.keys(namespaces)[0]
      goog.require namespace if namespace
      true

    gulp.src changedFilePath ? paths
      .pipe filter autoRequire
      .pipe mocha reporter: 'dot',  ui: 'tdd'

  ###*
    @param {string} baseJsDir
    @param {Array.<Object>} diContainers
    @return {Stream} Node.js Stream.
  ###
  diContainer: (baseJsDir, diContainers) ->
    diContainer = require 'gulp-closure-dicontainer'

    streams = for container, i in diContainers
      gulp.src 'tmp/deps0.js'
        .pipe diContainer
          baseJsDir: baseJsDir
          fileName: container.name.toLowerCase().replace('.', '') + '.js'
          name: container.name
          resolve: container.resolve
        .pipe gulp.dest 'tmp'
        .pipe closureDeps prefix: @depsPrefix, fileName: "deps#{i+1}.js"
        .pipe gulp.dest 'tmp'
    eventStream.merge streams...

  ###*
    @return {Stream} Node.js Stream.
  ###
  concatDeps: ->
    gulp.src 'tmp/deps?.js'
      .pipe concat 'deps.js'
      .pipe gulp.dest 'tmp'

  ###*
    @param {Object} object
    @return {Stream} Node.js Stream.
  ###
  concatAll: (object) ->
    streams = for buildPath, src of object
      src = if @production
        src.production.concat buildPath
      else
        src.development
      gulp.src src
        .pipe concat path.basename buildPath
        .pipe cond @production, closureCompiler
          compilerPath: 'bower_components/closure-compiler/compiler.jar'
          fileName: path.basename buildPath
          compilerFlags: warning_level: 'QUIET'
        .pipe cond @production, size showFiles: true, gzip: true
        .pipe gulp.dest path.dirname buildPath
    eventStream.merge streams...

  liveReloadNotify: ->
    return if !@changedFilePath
    @liveReloadServer.changed @changedFilePath

  liveReloadServer: ->
    livereload = require 'gulp-livereload'
    @liveReloadServer = livereload()
    return

  ###*
    @return {boolean}
  ###
  shouldCreateDeps: ->
    closureDeps.changed @changedFilePath

  ###*
    @return {boolean}
  ###
  shouldNotify: ->
    !@production && @changedFilePath

  setNodeEnv: ->
    process.env['NODE_ENV'] = if @production
      'production'
    else
      'development'

  ###*
    @param {(string|Array.<string>)} paths
    @param {string} dest
    @param {Object} customOptions
    @return {Stream} Node.js Stream.
  ###
  compile: (paths, dest, customOptions) ->
    paths = [paths] if not Array.isArray paths
    options =
      fileName: 'app.js'
      compilerFlags:
        closure_entry_point: 'app.main'
        compilation_level: 'ADVANCED_OPTIMIZATIONS'
        define: [
          "goog.DEBUG=#{@production == 'debug'}"
        ]
        extra_annotation_name: 'jsx'
        only_closure_dependencies: true
        output_wrapper: '(function(){%output%})();'
        warning_level: 'VERBOSE'

    if @production == 'debug'
      # Debug and formatting makes compiled code readable.
      options.compilerFlags.debug = true
      options.compilerFlags.formatting = 'PRETTY_PRINT'

    _.merge options, customOptions, (a, b) ->
      return a.concat b if Array.isArray a

    gulp.src paths
      .pipe closureCompiler options
      .on 'error', (err) -> gutil.log err.message
      .pipe size showFiles: true, gzip: true
      .pipe gulp.dest dest

  ###*
    @param {string} dirs
    @return {Array.<string>}
  ###
  getExterns: (dir) ->
    fs.readdirSync dir
      .filter (file) -> /\.js$/.test file
      .filter (file) ->
        # Remove Stdio because it does not compile.
        # TODO(steida): Fork and fix these externs.
        file not in ['stdio.js']
      .map (file) -> path.join dir, file

  ###*
    @param {Array.<string>} dirs
    @param {Object} mapExtensionToTask
    @param {Function} gulpStartCallback
  ###
  watch: (dirs, mapExtensionToTask, gulpStartCallback) ->
    esteWatch = require 'este-watch'

    watch = esteWatch dirs, (e) =>
      @changedFilePath = path.resolve e.filepath
      task = mapExtensionToTask[e.extension]
      if task
        gulpStartCallback task
      else
        @changedFilePath = null
    watch.start()

  ###*
    @param {string} cmd
    @param {Array.<string>} args
  ###
  bg: (cmd, args) ->
    bg = require 'gulp-bg'
    bg cmd, args

  ###*
    @param {(string|Array.<string>)} paths
    @param {Object} yargs
    @param {Function} done
  ###
  bump: (paths, yargs, done) ->
    bump = require 'gulp-bump'
    git = require 'gulp-git'

    args = yargs.alias('m', 'minor').argv
    type = args.major && 'major' || args.minor && 'minor' || 'patch'

    gulp.src paths
      .pipe bump type: type
      .pipe gulp.dest './'
      .on 'end', =>
        version = require(path.join @dirname, 'package').version
        message = "Bump #{version}"
        gulp.src paths
          .pipe git.add()
          .pipe git.commit message
          .on 'end', ->
            git.push 'origin', 'master', {}, ->
              git.tag version, message, {}, ->
                git.push 'origin', 'master', args: ' --tags', done
    return

  ###*
    Remove transpiled files without their original source.
    @param {Object.<string, Array.<string>>} object Key is glob and value
      is list of extensions, for example: 'somefile.js': ['coffee', 'jsx']
  ###
  deleteOrphans: (object) ->
    rimraf = require 'gulp-rimraf'

    paths = Object.keys object
    targets = {}
    targets[glob.match /\.[^\.]+/] = exts for glob, exts of object
    isOrphan = (file) ->
      ext = path.extname file.path
      for target in targets[ext]
        return false if fs.existsSync file.path.replace ext, '.' + target
      true

    gulp.src paths, read: false
      .pipe filter isOrphan
      .pipe rimraf()

  ###*
    @param {string} target The file/uri to open.
    @param {string=} appName The application to be used to open the file. For
      example: 'chrome', 'firefox'.
    @return {ChildProcess} The child process object.
  ###
  open: (target, appName = '') ->
    open = require 'open'
    open target, appName

  ###*
    @param {string} depsFilePath
    @param {RegExp} regExp
    @return {Array.<string>}
  ###
  getProvidedNamespaces: (depsFilePath, regExp) ->
    provided = {}
    fs.readFileSync depsFilePath, 'utf8'
      .replace regExp, (match, namespace) ->
        provided[namespace] = true
    Object.keys provided