gulp = require 'gulp'
gutil = require 'gulp-util'
gulpif = require 'gulp-if'

coffee = require 'gulp-coffee'
browserify = require 'gulp-browserify'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
sass = require 'gulp-sass'
refresh = require 'gulp-livereload'
imagemin = require 'gulp-imagemin'

connect = require 'connect'
http = require 'http'
path = require 'path'
lr = require 'tiny-lr'
server = lr()
rmdir = require 'rimraf'

gulp.task 'webserver', ->
  port = 3000
  hostname = null
  base = path.resolve 'dist'
  directory = path.resolve 'dist'

  app = connect()
    .use connect.static base
    .use connect.directory directory

  http.createServer(app).listen port, hostname

# Starts the livereload server
gulp.task 'livereload', ->
  server.listen 35729, (err) ->
    console.log err if err?

gulp.task 'vendor', ->
  gulp.src 'scripts/vendor/*.js'
    .pipe concat 'vendor.js'
    .pipe gulp.dest 'dist/assets/'
    .pipe refresh server

gulp.task 'scripts', ->
  gulp.src 'scripts/coffee/app.coffee',  read: false
    .pipe browserify transform: ['coffeeify'], extensions: ['.coffee'], debug: !gutil.env.production
    .pipe concat 'scripts.js'
    .pipe gulpif gutil.env.production, uglify()
    .pipe gulp.dest 'dist/assets/'
    .pipe refresh server

gulp.task 'styles', ->
  gulp.src 'styles/scss/init.scss'
    .pipe sass includePaths: ['styles/scss/includes']
    .pipe concat 'styles.css'
    .pipe gulp.dest 'dist/assets/'
    .pipe refresh server

gulp.task 'html', ->
  gulp.src '*.html'
    .pipe gulp.dest 'dist/'
    .pipe refresh server

gulp.task 'images', ->
  gulp.src 'resources/images/**'
    .pipe imagemin()
    .pipe gulp.dest 'dist/assets/images/'
    .pipe refresh server

gulp.task 'sounds', ->
  gulp.src 'resources/sounds/**'
    .pipe gulp.dest 'dist/assets/sounds/'
    .pipe refresh server

gulp.task 'watch', ->
  gulp.watch 'scripts/vendor/**', ['vendor']
  gulp.watch 'scripts/coffee/**', ['scripts']
  gulp.watch 'styles/scss/**', ['styles']
  gulp.watch 'resources/images/**', ['images']
  gulp.watch 'resources/sounds/**', ['sounds']
  gulp.watch '*.html', ['html']

gulp.task 'clean', ->
  rmdir 'dist', () ->

gulp.task 'build', ['clean', 'vendor', 'scripts', 'styles', 'images', 'sounds', 'html']

gulp.task 'default', ['webserver', 'livereload', 'build', 'watch']
