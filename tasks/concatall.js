// Generated by CoffeeScript 1.7.1
(function() {
  var gulp;

  gulp = require('gulp');


  /**
    @param {Object} object
    @param {Object=} compilerFlags
    @return {Stream} Node.js Stream.
   */

  module.exports = function(object, compilerFlags) {
    var buildPath, closureCompiler, concat, cond, eventStream, gutil, path, size, src, streams;
    if (compilerFlags == null) {
      compilerFlags = {};
    }
    closureCompiler = require('gulp-closure-compiler');
    concat = require('gulp-concat');
    cond = require('gulp-cond');
    eventStream = require('event-stream');
    gutil = require('gulp-util');
    path = require('path');
    size = require('gulp-size');
    if (compilerFlags.warning_level == null) {
      compilerFlags.warning_level = 'QUIET';
    }
    streams = (function() {
      var _results;
      _results = [];
      for (buildPath in object) {
        src = object[buildPath];
        src = this.production ? src.production.concat(buildPath) : src.development;
        _results.push(gulp.src(src).pipe(concat(path.basename(buildPath))).pipe(cond(this.production, closureCompiler({
          compilerPath: 'bower_components/closure-compiler/compiler.jar',
          fileName: path.basename(buildPath),
          compilerFlags: compilerFlags
        }))).on('error', function(err) {
          return gutil.log(gutil.colors.red(err.message));
        }).pipe(cond(this.production, size({
          showFiles: true,
          gzip: true
        }))).pipe(gulp.dest(path.dirname(buildPath))));
      }
      return _results;
    }).call(this);
    return eventStream.merge.apply(eventStream, streams);
  };

}).call(this);