// Generated by CoffeeScript 1.7.1
(function() {
  module.exports = function() {
    var Q, deferred;
    Q = require('q');
    deferred = Q.defer();
    setTimeout(function() {
      return deferred.resolve();
    }, 1);
    this.liveReload = require('gulp-livereload');
    this.liveReload.listen();
    return deferred.promise;
  };

}).call(this);