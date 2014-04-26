gulp = require 'gulp'

###*
  @return {Stream} Node.js Stream.
###
module.exports = ->
  concat = require 'gulp-concat'

  gulp.src 'tmp/deps?.js'
    .pipe concat 'deps.js'
    .pipe gulp.dest 'tmp'