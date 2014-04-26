gulp = require 'gulp'

module.exports = ->
  liveReload = require 'gulp-livereload'

  @liveReload = liveReload()
  return