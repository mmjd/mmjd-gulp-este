gulp = require 'gulp'

###*
  @param {string} baseJsDir
  @param {Array.<Object>} diContainers
  @return {Stream} Node.js Stream.
###
module.exports = (baseJsDir, diContainers) ->
  closureDeps = require 'gulp-closure-deps'
  diContainer = require 'gulp-closure-dicontainer'
  eventStream = require 'event-stream'

  streams = for container, i in diContainers
    gulp.src 'tmp/deps0.js'
      .pipe diContainer
        baseJsDir: baseJsDir
        fileName: container.name.toLowerCase().replace('.', '') + '.js'
        name: container.name
        resolve: container.resolve
      .pipe gulp.dest 'tmp'
      .pipe closureDeps prefix: @depsPrefix, fileName: "deps#{i+1}.js"
      .pipe gulp.dest 'tmp'
  eventStream.merge streams...