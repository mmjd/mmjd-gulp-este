gulp = require 'gulp'

###*
  @param {(string|Array.<string>)} paths
  @param {string} dest
  @param {Object} customOptions
  @return {Stream} Node.js Stream.
###
module.exports = (paths, dest, customOptions) ->
  _ = require 'lodash'
  closureCompiler = require 'gulp-closure-compiler'
  gutil = require 'gulp-util'
  size = require 'gulp-size'

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
    .on 'error', (err) -> gutil.log gutil.colors.red err.message
    .pipe size showFiles: true, gzip: true
    .pipe gulp.dest dest