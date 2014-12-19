gulp = require 'gulp'
gulpWebpack = require 'gulp-webpack'
named = require('vinyl-named');

changed = require 'gulp-changed'
gutil = require 'gulp-util'

##
paths =
  other: [
    'src/**/*.js'
    '!src/**/*.js'
    '!src/**/*.coffee'
    '!src/**/*.scss'
  ]
  targetDir: '../asset/js'

gulp.task 'default', ->
    console.log 'default task...'
    gulp.watch paths.other, ['assets_update']

gulp.task 'webpack' , ->
    return gulp.src([
        'src/entry.js'
        'src/spi/chatroom/index.coffee'
        ])
        .pipe(named())
        .pipe(gulpWebpack(

            module:
                loaders: [
                    { test: /\.css$/, loader: 'style!css' },
                    { test: /\.coffee$/, loader: "coffee-loader" }
                ]
            #                preLoaders: [
            #                    { test: /\.coffee$/, loader: "coffee-hint-loader" }
            #                ]

        ))
        .pipe(gulp.dest('../assets/js'))


# gulp other, moves changed files from source to other
gulp.task 'assets_update', ->
  gulp.src paths.other
  .pipe changed paths.targetDir
  .pipe gulp.dest paths.targetDir
