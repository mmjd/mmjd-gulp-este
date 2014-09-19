// Generated by CoffeeScript 1.7.1
(function() {
  var GulpEste;

  module.exports = GulpEste = (function() {

    /**
      @param {string} dirname __dirname or something else.
      @param {boolean} production Production flag.
      @param {string=} depsPrefix Optional deps prefix.
     */
    function GulpEste(dirname, production, depsPrefix) {
      this.dirname = dirname;
      this.production = production;
      this.depsPrefix = depsPrefix;
      this.changedFilePath = null;
    }

    GulpEste.prototype.bg = require('./tasks/bg');

    GulpEste.prototype.bump = require('./tasks/bump');

    GulpEste.prototype.coffee = require('./tasks/coffee');

    GulpEste.prototype.compile = require('./tasks/compile');

    GulpEste.prototype.concatAll = require('./tasks/concatall');

    GulpEste.prototype.concatDeps = require('./tasks/concatdeps');

    GulpEste.prototype.deleteOrphans = require('./tasks/deleteorphans');

    GulpEste.prototype.deps = require('./tasks/deps');

    GulpEste.prototype.diContainer = require('./tasks/dicontainer');

    GulpEste.prototype.getExterns = require('./tasks/getexterns');

    GulpEste.prototype.getNodeJsExterns = require('./tasks/getnodejsexterns');

    GulpEste.prototype.getProvidedNamespaces = require('./tasks/getprovidednamespaces');

    GulpEste.prototype.jsx = require('./tasks/jsx');

    GulpEste.prototype.liveReloadNotify = require('./tasks/livereloadnotify');

    GulpEste.prototype.liveReloadServer = require('./tasks/livereloadserver');

    GulpEste.prototype.open = require('./tasks/open');

    GulpEste.prototype.setNodeEnv = require('./tasks/setnodeenv');

    GulpEste.prototype.shouldCreateDeps = require('./tasks/shouldcreatedeps');

    GulpEste.prototype.shouldNotify = require('./tasks/shouldnotify');

    GulpEste.prototype.stylus = require('./tasks/stylus');

    GulpEste.prototype.unitTest = require('./tasks/unittest');

    GulpEste.prototype.watch = require('./tasks/watch');

    return GulpEste;

  })();

}).call(this);
