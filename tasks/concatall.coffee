gulp = require 'gulp'

###*
  @param {Object} object
  @param {Object=} compilerFlags
  @return {Stream} Node.js Stream.
###
module.exports = (object, compilerFlags = {}) ->
  closureCompiler = require 'gulp-closure-compiler'
  concat = require 'gulp-concat'
  cond = require 'gulp-cond'
  eventStream = require 'event-stream'
  gutil = require 'gulp-util'
  path = require 'path'
  size = require 'gulp-size'

  compilerFlags.warning_level ?= 'QUIET'

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
        compilerFlags: compilerFlags
      .on 'error', (err) -> gutil.log gutil.colors.red err.message
      .pipe cond @production, size showFiles: true, gzip: true
      .pipe gulp.dest path.dirname buildPath
  eventStream.merge streams...