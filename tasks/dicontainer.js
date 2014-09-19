// Generated by CoffeeScript 1.7.1
(function() {
  var gulp;

  gulp = require('gulp');


  /**
    @param {string} baseJsDir
    @param {Array.<Object>} diContainers
    @return {Stream} Node.js Stream.
   */

  module.exports = function(baseJsDir, diContainers) {
    var closureDeps, container, diContainer, eventStream, gutil, i, streams;
    closureDeps = require('gulp-closure-deps');
    diContainer = require('gulp-closure-dicontainer');
    eventStream = require('event-stream');
    gutil = require('gulp-util');
    streams = (function() {
      var _i, _len, _results;
      _results = [];
      for (i = _i = 0, _len = diContainers.length; _i < _len; i = ++_i) {
        container = diContainers[i];
        _results.push(gulp.src('tmp/deps0.js').pipe(diContainer({
          baseJsDir: baseJsDir,
          fileName: container.name.toLowerCase().replace('.', '') + '.js',
          name: container.name,
          resolve: container.resolve
        })).on('error', function(err) {
          return gutil.log(gutil.colors.red(err.message));
        }).pipe(gulp.dest('tmp')).pipe(closureDeps({
          prefix: this.depsPrefix,
          fileName: "deps" + (i + 1) + ".js"
        })).pipe(gulp.dest('tmp')));
      }
      return _results;
    }).call(this);
    return eventStream.merge.apply(eventStream, streams);
  };

}).call(this);