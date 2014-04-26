gulp = require 'gulp'

###*
  @param {Array.<string>} dirs
  @param {Object} mapExtensionToTask
  @param {Function} gulpStartCallback
###
module.exports = (dirs, mapExtensionToTask, gulpStartCallback) ->
  esteWatch = require 'este-watch'
  path = require 'path'

  watch = esteWatch dirs, (e) =>
    @changedFilePath = path.resolve e.filepath
    task = mapExtensionToTask[e.extension]
    if task
      gulpStartCallback task
    else
      @changedFilePath = null
  watch.start()