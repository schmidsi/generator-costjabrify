# generated on <%= (new Date).toISOString().split('T')[0] %> using <%= pkg.name %> <%= pkg.version %>

browserSync = require 'browser-sync'
browserify  = require 'browserify'
gulp        = require 'gulp'
gutil       = require 'gulp-util'
jade        = require 'gulp-jade'
notify      = require 'gulp-notify'
nodemon     = require 'gulp-nodemon'
pkg         = require './package.json'
plumber     = require 'gulp-plumber'
source      = require 'vinyl-source-stream'
stylus      = require 'gulp-stylus'


delay = (ms, func) -> setTimeout func, ms

paths =
    jade:   ['./frontend/templates/**/*.jade'] # <%= frontendDir %>
    stylus:
        watch:      ['./frontend/styles/**/*.styl']
        compile:    ['./frontend/styles/main.styl']
    coffee:
        path:       './frontend/scripts/**/*.coffee'
        main:       './frontend/scripts/main.coffee'
    dist:
        html:       './dist'
        js:         './dist/js/'
        css:        './dist/css/'


gulp.task 'brower-sync', ['browserify'], ->
    browserSync.init
        proxy    : 'http://localhost:3000'
        port     : 8000
        browser  : 'google chrome canary'
        ghostMode:
            clicks   : true
            location : true
            forms    : true
            scroll   : false


gulp.task 'browser-reload', ['browserify'], ->
    browserSync.reload()


gulp.task 'browserify', ->
    return browserify
            extensions: ['.coffee']
            debug:      true
            fullPaths:  true
            entries:    paths.coffee.main
        .bundle()
        .on 'error', notify.onError("Browserify error: <%= error.message %>")
        .pipe source('bundle.js')
        .pipe gulp.dest(paths.dist.js)


gulp.task 'nodemon', (next) ->
    called = false

    nodemon
        script: pkg.main
        ext:    'coffee'
        ignore: [
            '.git'
            'node_modules/**'
            'node_modules'
            paths.coffee.path
            paths.jade
            'bower_components'
            '.sass-cache'
            './public/**/*.js']
        env:
            'NODE_ENV': 'development'

    .on 'start', ->
        if not called
            delay 1000, ->
                called = true
                next()

    .on 'restart', ->
        delay 1000, ->
            browserSync.reload stream: false


gulp.task 'stylus', ->
    return gulp.src(paths.stylus.compile)
        .pipe plumber()
        .pipe stylus
            use: [
                ## Uncomment following lines to use stylus plugins
                #require('nib')()
                #require('rupture')()
                #require('axis')()
            ]
        .on 'error', notify.onError("Stylus Error: <%= error.message %>")
        .pipe gulp.dest(paths.dist.css)
        .pipe browserSync.reload(stream: true)


gulp.task 'jade', ->
    return gulp.src(paths.jade)
        .pipe jade
            pretty: true
        .on 'error', notify.onError("Jade Error: <%= error.message %>")
        .pipe gulp.dest paths.dist.html


gulp.task 'default', ['nodemon', 'brower-sync', 'stylus', 'browserify'], ->
    gulp.watch paths.jade, ['browser-reload']
    gulp.watch paths.stylus.watch, ['stylus']
    gulp.watch paths.coffee.path, ['browserify', 'browser-reload']

    # type "br <return>"  in the commandline window to reload all browsers manually
    stdin = process.stdin
    stdin.resume()
    stdin.setEncoding 'utf8'

    stdin.on 'data', (data) ->
        if data is '\u0003'
            process.exit()

        if 'br' is data.trim()
            browserSync.reload stream: false
            gutil.log('Reload all browsers')

