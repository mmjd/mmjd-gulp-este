var cond, eventStream, gulp, plumber, rename, stylus;

gulp = require('gulp');

cond = require('gulp-cond');

eventStream = require('event-stream');

plumber = require('gulp-plumber');

rename = require('gulp-rename');

stylus = require('gulp-stylus');


/**
  @param {(string|Array.<string>)} paths
  @return {Stream} Node.js Stream.
 */

module.exports = function(paths) {
  var streams, watchMode;
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
        set: ['include css'],
        errors: true
      })).pipe(gulp.dest('.')).pipe(rename(function(path) {
        path.dirname = path.dirname.replace('/css', '/build');
      })).pipe(cond(_this.production, minifyCss())).pipe(gulp.dest('.'));
    };
  })(this));
  return eventStream.merge.apply(eventStream, streams);
};
