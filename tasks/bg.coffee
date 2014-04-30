###*
  @param {string} cmd
  @param {Array.<string>} args
###
module.exports = (cmd, args) ->
  bg = require 'gulp-bg'

  bg cmd, args
