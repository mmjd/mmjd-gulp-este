module.exports = ->
  Q = require 'q'

  # Ensure "Live reload server listening on: 35729" console message is shown
  # right after "Starting 'livereload-notify'".
  deferred = Q.defer();
  setTimeout ->
    deferred.resolve()
  , 1

  @liveReload = require 'gulp-livereload'
  @liveReload.listen()

  deferred.promise