gulp       = require 'gulp'
coffee     = require 'gulp-coffee'
watchify   = require 'gulp-watchify'

watching = false
gulp.task 'enable-watch-mode', -> watching = true

gulp.task 'build:coffee', ->
  gulp.src './src/*.coffee'
    .pipe coffee()
    .pipe gulp.dest './js'

gulp.task 'browserify', watchify (watchify)->
  gulp.src './js/main.js'
    .pipe watchify
      watch : watching
    .pipe gulp.dest './'

gulp.task 'watchify', ['enable-watch-mode', 'browserify']

gulp.task 'watch', ['build:coffee', 'watchify'], ->
  gulp.watch 'src/*.coffee', ['build:coffee']

gulp.task 'default', ['browserify']
