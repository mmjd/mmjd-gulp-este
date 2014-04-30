module.exports = ->
  return if !@changedFilePath || !@liveReload
  @liveReload.changed @changedFilePath