gulp = require 'gulp'

###*
  @return {boolean}
###
module.exports = ->
  !@production && @changedFilePath