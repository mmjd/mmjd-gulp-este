###*
  @return {Array.<string>}
###
module.exports = ->
  nodeJsExterns = require 'nodejs-externs'

  return nodeJsExterns.getExternsAsListOfResolvedPaths()