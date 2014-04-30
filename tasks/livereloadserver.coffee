module.exports = ->
  Q = require 'q'
  liveReload = require 'gulp-livereload'

  @liveReload = liveReload()

  # Ensure "Live reload server listening on: 35729" is shown right after
  # "Starting 'livereload-notify'" in gulp log output.
  deferred = Q.defer();
  setTimeout ->
    deferred.resolve()
  , 1
  deferred.promise