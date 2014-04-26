gulp = require 'gulp'

###*
  @param {string} depsFilePath
  @param {RegExp} regExp
  @return {Array.<string>}
###
module.exports = (depsFilePath, regExp) ->
  fs = require 'fs'

  provided = {}
  fs.readFileSync depsFilePath, 'utf8'
    .replace regExp, (match, namespace) ->
      provided[namespace] = true
  Object.keys provided