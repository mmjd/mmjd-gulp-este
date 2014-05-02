###*
  @param {Array.<string>} dirs
  @param {Object} mapExtensionToTask
  @param {Function} gulpStartCallback
  @param {Object=} options
###
module.exports = (dirs, mapExtensionToTask, gulpStartCallback, options = {}) ->
  esteWatch = require 'este-watch'
  path = require 'path'

  options.ignoredDirs ?= ['build']

  watch = esteWatch dirs, (e) =>
    filePath = path.resolve e.filepath

    for dir in options.ignoredDirs
      return if filePath.indexOf(dir + '/') > -1

    @changedFilePath = filePath
    task = mapExtensionToTask[e.extension]
    if task
      gulpStartCallback task
    else
      @changedFilePath = null
  watch.start()