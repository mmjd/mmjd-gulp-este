###*
  @param {string} dirs
  @return {Array.<string>}
###
module.exports = (dir) ->
  fs = require 'fs'
  path = require 'path'

  fs.readdirSync dir
    .filter (file) -> /\.js$/.test file
    .filter (file) ->
      # Remove Stdio because it does not compile.
      # TODO(steida): Fork and fix these externs.
      file not in ['stdio.js']
    .map (file) -> path.join dir, file