gulp = require 'gulp'
gutil = require 'gulp-util'

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

gulp.task 'webserver', ->
  port = 3000
  hostname = null
  base = path.resolve '.'
  directory = path.resolve '.'

  app = connect()
    .use connect.static base
    .use connect.directory directory

  http.createServer(app).listen port, hostname

# Starts the livereload server
gulp.task 'livereload', ->
  server.listen 35729, (err) ->
    console.log err if err?

gulp.task 'scripts', ->
  gulp.src 'scripts/vendor/*.js'
    .pipe concat 'vendor.js'
    .pipe gulp.dest 'assets/'
    .pipe refresh server

  gulp.src 'scripts/coffee/app.coffee',  read: false
    .pipe browserify transform: ['coffeeify'], extensions: ['.coffee']
    .pipe concat 'scripts.js'
    .pipe gulp.dest 'assets/'
    .pipe refresh server

gulp.task 'styles', ->
  gulp.src 'styles/scss/init.scss'
    .pipe sass includePaths: ['styles/scss/includes']
    .pipe concat 'styles.css'
    .pipe gulp.dest 'assets/'
    .pipe refresh server

gulp.task 'html', ->
  gulp.src '*.html'
    .pipe refresh server

gulp.task 'images', ->
  gulp.src 'resources/images/**'
    .pipe imagemin()
    .pipe gulp.dest 'assets/images/'

gulp.task 'watch', ->
  gulp.watch 'scripts/coffee/**', ['scripts']
  gulp.watch 'styles/scss/**', ['styles']
  gulp.watch 'resources/images/**', ['images']
  gulp.watch '*.html', ['html']

gulp.task 'default', ['webserver', 'livereload', 'scripts', 'styles', 'images', 'watch']

