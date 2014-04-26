gulp = require 'gulp'

module.exports = ->
  return if !@changedFilePath || !@liveReload
  @liveReload.changed @changedFilePath