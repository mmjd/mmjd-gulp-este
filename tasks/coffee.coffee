gulp = require 'gulp'

###*
  TODO: Error should stop build.
  @param {(string|Array.<string>)} paths
  @param {Object=} options
  @return {Stream} Node.js Stream.
###
module.exports = (paths, options = {}) ->
  coffee = require 'gulp-coffee'
  coffee2closure = require 'gulp-coffee2closure'
  cond = require 'gulp-cond'
  gutil = require 'gulp-util'
  plumber = require 'gulp-plumber'
  rename = require 'gulp-rename'

  ###
  Example:
  gulp.task 'coffee', ->
    este.coffee paths.coffee, rename: (path) ->
      path.dirname = path.dirname.replace /^src/, (dir) -> 'js'
  ###
  renameCallback = options.rename ? ->

  paths = [paths] if not Array.isArray paths
  gulp.src @changedFilePath ? paths, base: '.'
    .pipe cond @changedFilePath, plumber()
    .pipe coffee bare: true
    .on 'error', (err) -> gutil.log gutil.colors.red err.message
    .pipe coffee2closure()
    .pipe rename (path) ->
      renameCallback path
      return
    .pipe gulp.dest '.'