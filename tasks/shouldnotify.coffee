###*
  @return {boolean}
###
module.exports = ->
  !@production && @changedFilePath