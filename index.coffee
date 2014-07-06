module.exports = class GulpEste

  ###*
    @param {string} dirname __dirname or something else.
    @param {boolean} production Production flag.
    @param {string=} depsPrefix Optional deps prefix.
  ###
  constructor: (@dirname, @production, @depsPrefix) ->
    @changedFilePath = null

  bg: require './tasks/bg'
  bump: require './tasks/bump'
  coffee: require './tasks/coffee'
  compile: require './tasks/compile'
  concatAll: require './tasks/concatall'
  concatDeps: require './tasks/concatdeps'
  deleteOrphans: require './tasks/deleteorphans'
  deps: require './tasks/deps'
  diContainer: require './tasks/dicontainer'
  getExterns: require './tasks/getexterns'
  getNodeJsExterns: require './tasks/getnodejsexterns'
  getProvidedNamespaces: require './tasks/getprovidednamespaces'
  jsx: require './tasks/jsx'
  liveReloadNotify: require './tasks/livereloadnotify'
  liveReloadServer: require './tasks/livereloadserver'
  open: require './tasks/open'
  setNodeEnv: require './tasks/setnodeenv'
  shouldCreateDeps: require './tasks/shouldcreatedeps'
  shouldNotify: require './tasks/shouldnotify'
  stylus: require './tasks/stylus'
  unitTest: require './tasks/unittest'
  watch: require './tasks/watch'