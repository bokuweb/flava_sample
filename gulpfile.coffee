gulp     = require 'gulp'
coffee   = require 'gulp-coffee'
watchify = require 'gulp-watchify'

compile = ->
  gulp.src 'src/*.coffee'
    .pipe coffee()
    .pipe gulp.dest 'js'

gulp.task 'build:coffee', -> compile()

gulp.task 'watchify', watchify (watchify)->
  gulp.src 'js/main.js'
    .pipe watchify
      watch : off
    .pipe gulp.dest './'

gulp.task 'watch', ['build:coffee'], ->
  gulp.watch 'src/*.coffee', ['watchify']
    .on 'change', -> compile()
