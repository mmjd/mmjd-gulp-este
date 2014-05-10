gulp = require 'gulp'

###*
  @param {(string|Array.<string>)} paths
  @param {Object=} options
  @return {Stream} Node.js Stream.
###
module.exports = (paths, options = {}) ->
  cond = require 'gulp-cond'
  gutil = require 'gulp-util'
  jsx = require 'gulp-react'
  plumber = require 'gulp-plumber'
  rename = require 'gulp-rename'

  # Example:
  # srcToJs = (path) ->
  #   path.dirname = path.dirname.replace /^src/, (dir) -> 'js'
  # gulp.task 'coffee', ->
  #   este.coffee paths.coffee, rename: srcToJs
  renameCallback = options.rename ? ->

  paths = [paths] if not Array.isArray paths
  gulp.src @changedFilePath ? paths, base: '.'
    .pipe cond @changedFilePath, plumber()
    .pipe jsx harmony: true
    .on 'error', (err) ->
      gutil.log gutil.colors.red err.fileName + ': ' + err.message
    .pipe rename (path) ->
      renameCallback path
      return
    .pipe gulp.dest '.'