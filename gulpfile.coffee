gulp = require 'gulp'

GulpEste = require './index'
coffee = require 'gulp-coffee'
gutil = require 'gulp-util'
yargs = require 'yargs'

este = new GulpEste __dirname, true

gulp.task 'coffee', ->
  gulp.src ['index.coffee', 'tasks/**/*.coffee'], base: '.'
    .pipe coffee bare: true
      .on 'error', gutil.log
    .pipe gulp.dest '.'

gulp.task 'test', ['coffee'], ->

gulp.task 'bump', ['coffee'], (done) ->
  este.bump './*.json', yargs, done