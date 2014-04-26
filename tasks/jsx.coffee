gulp = require 'gulp'

###*
  @param {(string|Array.<string>)} paths
  @return {Stream} Node.js Stream.
###
module.exports = (paths) ->
  cond = require 'gulp-cond'
  gutil = require 'gulp-util'
  jsx = require 'gulp-react'
  plumber = require 'gulp-plumber'

  paths = [paths] if not Array.isArray paths
  gulp.src @changedFilePath ? paths, base: '.'
    .pipe cond @changedFilePath, plumber()
    .pipe jsx harmony: true
    .on 'error', (err) -> gutil.log gutil.colors.red err.message
    .pipe gulp.dest '.'