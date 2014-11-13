/*global describe, beforeEach, it*/
'use strict';

var path = require('path');
var assert = require('yeoman-generator').assert;
var helpers = require('yeoman-generator').test;
var os = require('os');

describe('costjabrify:app', function () {
  before(function (done) {
    helpers.run(path.join(__dirname, '../app'))
      .inDir(path.join(os.tmpdir(), './temp-test'))
      .withOptions({ 'skip-install': true })
      .on('end', done);
  });

  it('creates files', function () {
    assert.file([
      '.editorconfig',
      '.gitignore',
      'bower.json',
      'package.json',
      'gulpfile.coffee',
      'server.coffee',
      'app/images/logo.svg',
      'app/scripts/main.coffee',
      'app/styles/main.styl',
      'app/views/index.jade'
    ]);
  });
});
