gulp = require('gulp')
coffee = require("gulp-coffee")
concat = require("gulp-concat")
rjs = require('gulp-requirejs')##https://www.npmjs.org/package/gulp-requirejs
amdOptimize = require("amd-optimize") ##https://www.npmjs.org/package/amd-optimize/
#https://www.npmjs.org/package/gulp-requirejs-optimizer

gulp.task "scripts:player", ->
    gulp.src(['www/coffee/*.coffee'])
        .pipe(coffee())
        #.pipe(concat("page.js"))
        #.pipe(gulp.dest("www-build/js"))
        .pipe(amdOptimize("page",{
            baseUrl : "js"
            paths :
                'underscore'    : 'www/js/libs/underscore'
                "backbone" : "www/js/libs/backbone",
                "jquery" : "www/js/libs/jquery"
                'store'         : 'www/js/libs/store'
                'pdfjs'         : 'www/js/libs/pdfjs/pdf'
                'pdfjs-compat'  : 'www/js/libs/pdfjs/compatibility'

            #dir: 'www-built'
            #appDir: 'www'
            #baseUrl: 'js'
            optimize: 'uglify2'
            optimizeCss: 'none'
            fileExclusionRegExp: /(?:^\.)|(?:\.coffee$)|(?:\.s[ac]ss$)|(?:\.iml$)/
            removeCombined: true
            findNestedDependencies: true
            exclude: [
                'underscore'
                'jquery'
                'backbone'
            ]
            shim:
                #              'pdfjs':
                #                deps: [ 'pdfjs-compat' ]
                #                #init: ->
                #                #  #@PDFJS.workerSrc = 'www/js/js/libs/pdfjs/pdf.worker.js'
                #                #  return @PDFJS

                'underscore':
                    exports: '_'

                'backbone':
                    deps: [ 'underscore', 'jquery' ]
                    exports: 'Backbone'
            #            modules: [
            #              {
            #                name: 'core'
            #                include: [
            #                  'underscore'
            #                  'jquery'
            #                  'backbone'
            #                ]
            #              }
            #              {
            #                name: 'page'
            #                exclude: [ 'core' ]
            #              }
            #]

        }))#, { baseUrl: 'www/coffee'}))
        .pipe(concat("page.js"))
        .pipe(gulp.dest("../assets"))



gulp.task 'default', ["scripts:player"], ->
    console.log 'Default test task run'
    #gulp.start "scripts:player"
    gulp.watch(['www/coffee/*.coffee'],[
        "scripts:player"
    ]);