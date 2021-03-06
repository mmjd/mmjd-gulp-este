// Generated by CoffeeScript 1.7.1

/**
  @param {Array.<string>} dirs
  @param {Object} mapExtensionToTask
  @param {Function} gulpStartCallback
  @param {Object=} options
 */

(function() {
  module.exports = function(dirs, mapExtensionToTask, gulpStartCallback, options) {
    var esteWatch, path, watch;
    if (options == null) {
      options = {};
    }
    esteWatch = require('este-watch');
    path = require('path');
    if (options.ignoredDirs == null) {
      options.ignoredDirs = ['build'];
    }
    watch = esteWatch(dirs, (function(_this) {
      return function(e) {
        var dir, filePath, task, _i, _len, _ref;
        filePath = path.resolve(e.filepath);
        _ref = options.ignoredDirs;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          dir = _ref[_i];
          if (filePath.indexOf(dir + '/') > -1) {
            return;
          }
        }
        _this.changedFilePath = filePath;
        task = mapExtensionToTask[e.extension];
        if (task) {
          return gulpStartCallback(task);
        } else {
          return _this.changedFilePath = null;
        }
      };
    })(this));
    return watch.start();
  };

}).call(this);
