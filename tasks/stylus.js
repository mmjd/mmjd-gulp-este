// Generated by CoffeeScript 1.7.1
(function() {
  var gulp;

  gulp = require('gulp');


  /**
    @param {(string|Array.<string>)} paths
    @return {Stream} Node.js Stream.
   */

  module.exports = function(paths) {
    var cond, eventStream, minifyCss, pathOs, plumber, rename, streams, stylus, watchMode;
    cond = require('gulp-cond');
    eventStream = require('event-stream');
    minifyCss = require('gulp-minify-css');
    plumber = require('gulp-plumber');
    rename = require('gulp-rename');
    stylus = require('gulp-stylus');
    pathOs = require('path');
    watchMode = !!this.changedFilePath;
    if (!Array.isArray(paths)) {
      paths = [paths];
    }
    streams = paths.map((function(_this) {
      return function(path) {
        return gulp.src(path, {
          base: '.'
        }).pipe(plumber(function(error) {
          if (watchMode) {
            return this.emit('end');
          }
        })).pipe(stylus({
          'include css': true,
          errors: true
        })).pipe(gulp.dest('.')).pipe(rename(function(path) {
          var buildPath, cssPath;
          cssPath = pathOs.normalize('/css');
          buildPath = pathOs.normalize('/build');
          path.dirname = path.dirname.replace(cssPath, buildPath);
        })).pipe(cond(_this.production, minifyCss())).pipe(gulp.dest('.'));
      };
    })(this));
    return eventStream.merge.apply(eventStream, streams);
  };

}).call(this);
