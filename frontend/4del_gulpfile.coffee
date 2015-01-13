## https://www.npmjs.com/package/amd-optimize/
#gulp = require('./build/tasks')([
#    'default2'
#])
gulp = require('gulp')
amdOptimize = require("amd-optimize") ## https://github.com/scalableminds/amd-optimize

rjs = require('gulp-requirejs')#https://www.npmjs.com/package/gulp-requirejs

paths =
    other: [
        'src/**/*.js'
        '!src/**/*.js'
        '!src/**/*.coffee'
        '!src/**/*.scss'
    ]
    targetDir: '../asset/js'



gulp.task 'spa_management', ->
    console.log 'START == build SPA management...'
    rjs(
        baseUrl: './src/spa',
        mainConfigFile: "./src/main.config.js",
        #name: './../bootstrap_app'
        name: './../../node_modules/almond/almond',
        paths:
            'page': 'management'
        include:['./../bootstrap_app']
        exclude:['coffee-script']
        #out:'./test/app.main.js'
        out: './../../assets/js/spa/management.js'
        findNestedDependencies: true
        insertRequire: ['../bootstrap_app']
        stubModules: ['text', 'cs'],
        CoffeeScript:
            bare: false
        wrap: true
    ).pipe(
        gulp.dest('./delpoy/')
    )
    console.log 'END == build SPA management...'
gulp.task "watch", ->
    gulp.watch('src/spa/management/**/*.*', ['spa_management']);

gulp.task 'default', ['spa_management'],->
    gulp.run('spa_management')
    console.log 'default task...'

    #    amdOptimize.src "./src/main",
    #        configFile : "./src/main.config.js"
    #        baseUrl: "/src"

#gulpWebpack = require 'gulp-webpack'
#named = require('vinyl-named');

#changed = require 'gulp-changed'
#gutil = require 'gulp-util'

##


    #gulp.watch paths.other, ['assets_update']

#gulp.task 'webpack' , ->
#    return gulp.src([
#        'src/entry.js'
#        'src/spi/chatroom/index.coffee'
#        ])
#        .pipe(named())
#        .pipe(gulpWebpack(
#
#            module:
#                loaders: [
#                    { test: /\.css$/, loader: 'style!css' },
#                    { test: /\.coffee$/, loader: "coffee-loader" }
#                ]
#            #                preLoaders: [
#            #                    { test: /\.coffee$/, loader: "coffee-hint-loader" }
#            #                ]
#
#        ))
#        .pipe(gulp.dest('../assets/js'))
#
#
## gulp other, moves changed files from source to other
#gulp.task 'assets_update', ->
#    gulp.src paths.other
#    .pipe changed paths.targetDir
#    .pipe gulp.dest paths.targetDir
