gulp = require 'gulp'

###*
  Remove transpiled files without their original source.
  @param {Object.<string, Array.<string>>} object Key is glob and value
    is list of extensions, for example: 'somefile.js': ['coffee', 'jsx']
###
module.exports = (object) ->
  filter = require 'gulp-filter'
  fs = require 'fs'
  path = require 'path'
  rimraf = require 'gulp-rimraf'

  paths = Object.keys object
  targets = {}
  targets[glob.match /\.[^\.]+/] = exts for glob, exts of object
  isOrphan = (file) ->
    ext = path.extname file.path
    for target in targets[ext]
      return false if fs.existsSync file.path.replace ext, '.' + target
    true

  gulp.src paths, read: false
    .pipe filter isOrphan
    .pipe rimraf()