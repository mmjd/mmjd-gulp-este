###*
  @param {string} dir
  @return {Array.<string>}
###
module.exports = (dir) ->
  throw "
    Method getExterns is deprecated. Use getNodeJsExterns() instead.
    Update your gulpfile 'compile-serverapp', check github.com/steida/este.
  "