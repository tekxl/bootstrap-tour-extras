gulp = require 'gulp'
$ = require('gulp-load-plugins') lazy: false

paths =
  src: './src'
  dist: './build'
  test: './test'

# coffee
gulp.task 'coffee', ->
  gulp
  .src "#{paths.src}/coffee/*.coffee"
  .pipe $.changed "#{paths.dist}/js"
  .pipe $.coffeelint './coffeelint.json'
  .pipe $.coffeelint.reporter()
    .on 'error', $.util.log
  .pipe $.coffee bare: true
    .on 'error', $.util.log
  .pipe gulp.dest "#{paths.dist}/js"
  .pipe gulp.dest paths.test
  .pipe $.uglify()
  .pipe $.rename suffix: '.min'
  .pipe gulp.dest "#{paths.dist}/js"

# less
gulp.task 'less', ->
  gulp
  .src [
    "#{paths.src}/less/*.less"
  ]
  .pipe $.changed "#{paths.dist}/css"
  .pipe $.less()
    .on 'error', $.util.log
  .pipe gulp.dest "#{paths.dist}/css"
  .pipe $.less compress: true, cleancss: true
  .pipe $.rename suffix: '.min'
  .pipe gulp.dest "#{paths.dist}/css"

# clean
gulp.task 'clean-dist', ->
  gulp
  .src paths.dist
  .pipe $.clean()

gulp.task 'clean-test', ->
  gulp
  .src paths.test
  .pipe $.clean()

gulp.task 'watch', ->
  gulp.watch "#{paths.src}/coffee/*", ['coffee']
  gulp.watch "#{paths.src}/less/*", ["less"]

# tasks
gulp.task 'clean', ['clean-dist', 'clean-test']
gulp.task 'dist', ['coffee','less']
gulp.task 'test', ['coffee', 'test-coffee']
gulp.task 'default', ['dist']
