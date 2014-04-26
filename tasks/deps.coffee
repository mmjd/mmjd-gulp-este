gulp = require 'gulp'

###*
  @param {(string|Array.<string>)} paths
  @return {Stream} Node.js Stream.
###
module.exports = (paths) ->
  closureDeps = require 'gulp-closure-deps'

  paths = [paths] if not Array.isArray paths
  gulp.src paths
    .pipe closureDeps fileName: 'deps0.js', prefix: @depsPrefix
    .pipe gulp.dest 'tmp'