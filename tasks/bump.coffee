gulp = require 'gulp'

###*
  @param {(string|Array.<string>)} paths
  @param {Object} yargs
  @param {Function} done
###
module.exports = (paths, yargs, done) ->
  bump = require 'gulp-bump'
  git = require 'gulp-git'
  path = require 'path'

  args = yargs.alias('m', 'minor').argv
  type = args.major && 'major' || args.minor && 'minor' || 'patch'

  gulp.src paths
    .pipe bump type: type
    .pipe gulp.dest './'
    .on 'end', =>
      version = require(path.join @dirname, 'package').version
      message = "Bump #{version}"
      gulp.src paths
        .pipe git.add()
        .pipe git.commit message
        .on 'end', ->
          git.push 'origin', 'master', {}, ->
            git.tag version, message, {}, ->
              git.push 'origin', 'master', args: ' --tags', done
  return