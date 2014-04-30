###*
  @param {string} target The file/uri to open.
  @param {string=} appName The application to be used to open the file. For
    example: 'chrome', 'firefox'.
  @return {ChildProcess} The child process object.
###
module.exports = (target, appName = '') ->
  open = require 'open'

  open target, appName