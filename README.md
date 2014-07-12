# [gulp](http://gulpjs.com)-este
[![Build Status](https://secure.travis-ci.org/steida/gulp-este.png?branch=master)](http://travis-ci.org/steida/gulp-este) [![Dependency Status](https://david-dm.org/steida/gulp-este.png)](https://david-dm.org/steida/gulp-este) [![devDependency Status](https://david-dm.org/steida/gulp-este/dev-status.png)](https://david-dm.org/steida/gulp-este#info=devDependencies)

> Gulp tasks for [Este.js](https://github.com/steida/este)

## Install

```
npm install --save-dev gulp-este
```

## Example

Take a look at Este.js [gulpfile.coffee](https://github.com/steida/este/blob/master/gulpfile.coffee).

## Task Helpers

- bg (run command line app with args)
- bump (bump packages version)
- coffee
- compile (via Closure Compiler)
- concatAll (concat all files for browser)
- concatDeps
- deleteOrphans (delete foo.js without foo.coffee, etc.)
- diContainer (generate DI containers)
- getExterns (retrieve Node.js externs files)
- liveReloadNotify
- liveReloadServer
- react
- setNodeEnv
- shouldCreateDeps (for watch mode, create deps only when needed)
- shouldNotify
- stylus
- unitTest
- watch

## Notes
Bump tasks is still using gulp-git 0.3.6, because 0.4.x introduces bugs,
which still are not resolved.

## License

MIT © [Daniel Steigerwald](https://github.com/steida)
