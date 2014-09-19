// Generated by CoffeeScript 1.7.1

/**
  @param {string} depsFilePath
  @param {RegExp} regExp
  @return {Array.<string>}
 */

(function() {
  module.exports = function(depsFilePath, regExp) {
    var fs, provided;
    fs = require('fs');
    provided = {};
    fs.readFileSync(depsFilePath, 'utf8').replace(regExp, function(match, namespace) {
      return provided[namespace] = true;
    });
    return Object.keys(provided);
  };

}).call(this);