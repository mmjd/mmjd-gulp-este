###*
  @return {boolean}
###
module.exports = ->
  closureDeps = require 'gulp-closure-deps'

  closureDeps.changed @changedFilePath