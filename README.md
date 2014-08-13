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
- coffee (CoffeeScript)
- compile (Closure Compiler)
- concatAll (concat all files for production)
- concatDeps (helper)
- deleteOrphans (delete foo.js without foo.coffee, etc.)
- diContainer (generate awesome DI containers)
- getNodeJsExterns
- jsx (React JSX)
- liveReloadNotify
- liveReloadServer
- setNodeEnv
- shouldCreateDeps (for watch mode, create deps only when needed)
- shouldNotify
- stylus
- unitTest
- watch

## Notes
Bump task is using gulp-git 0.3.6, because 0.4.x introduces bugs
which are still not resolved.

## License

MIT © [Daniel Steigerwald](https://github.com/steida)
