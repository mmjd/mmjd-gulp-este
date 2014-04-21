gulp = require 'gulp'

coffee = require 'gulp-coffee'
gutil = require 'gulp-util'
yargs = require 'yargs'

gulp.task 'coffee', ->
  gulp.src 'index.coffee'
    .pipe coffee bare: true
      .on 'error', gutil.log
    .pipe gulp.dest '.'

gulp.task 'test', ['coffee'], ->

gulp.task 'bump', ['coffee'], (done) ->
  este = require '.index'
  este.bump './*.json', yargs, done