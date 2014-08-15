gulp = require 'gulp'

###*
  @param {(string|Array.<string>)} paths
  @return {Stream} Node.js Stream.
###
module.exports = (paths) ->
  cond = require 'gulp-cond'
  eventStream = require 'event-stream'
  minifyCss = require 'gulp-minify-css'
  plumber = require 'gulp-plumber'
  rename = require 'gulp-rename'
  stylus = require 'gulp-stylus'
  pathOs = require 'path'

  # Don't emit error on build, only for watch mode.
  # It prevents false positive builds.
  watchMode = !!@changedFilePath
  paths = [paths] if not Array.isArray paths

  streams = paths.map (path) =>
    gulp.src path, base: '.'
      .pipe plumber (error) ->
        # This ensures watching is not interrupted on error.
        this.emit 'end' if watchMode
      .pipe stylus 'include css': true, errors: true
      .pipe gulp.dest '.'
      .pipe rename (path) ->
        cssPath = pathOs.normalize '/css'
        buildPath = pathOs.normalize '/build'
        path.dirname = path.dirname.replace cssPath, buildPath
        return
      .pipe cond @production, minifyCss()
      .pipe gulp.dest '.'
  eventStream.merge streams...
