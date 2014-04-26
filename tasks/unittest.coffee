gulp = require 'gulp'

fs = require 'fs'
path = require 'path'

globals = Object.keys global

###*
  @param {string} baseJsDir
  @param {(string|Array.<string>)} paths
  @return {Stream} Node.js Stream.
###
module.exports = (baseJsDir, paths) ->

  paths = [paths] if not Array.isArray paths
  nodejsPath = path.join baseJsDir, 'bootstrap/nodejs'
  changedFilePath = @changedFilePath

  if changedFilePath
    # Ensure changedFilePath is _test.js file.
    if !/_test\.js$/.test changedFilePath
      changedFilePath = changedFilePath.replace '.js', '_test.js'
    return if not fs.existsSync changedFilePath

  chai = require 'chai'
  filter = require 'gulp-filter'
  jsdom = require 'jsdom'
  mocha = require 'gulp-mocha'
  react = require 'react'
  requireUncache = require 'require-uncache'
  sinon = require 'sinon'

  # Clean global variables created during test. For instance: goog and este.
  Object.keys(global).forEach (key) =>
    return if globals.indexOf(key) > -1
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