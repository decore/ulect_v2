gulp = require('gulp')
coffee = require("gulp-coffee")
concat = require("gulp-concat")
amdOptimize = require("amd-optimize") ##https://www.npmjs.org/package/amd-optimize/

gulp.task "scripts:player", ->
    gulp.src(['coffee/*.coffee'])
        .pipe(coffee())
        .pipe(amdOptimize("page",{
            paths :
                'underscore': 'js/libs/underscore'
                "backbone"  : "js/libs/backbone"
                "jquery"    : "js/libs/jquery"
                'store'     : 'js/libs/store'
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
                'underscore':
                    exports: '_'
                'backbone':
                    deps: [ 'underscore', 'jquery' ]
                    exports: 'Backbone'
        }))
        .pipe(concat("page.js"))
        .pipe(gulp.dest("../assets"))

gulp.task "scripts:core", ->
    gulp.src(['coffee/*.coffee'])
        .pipe(coffee())
        .pipe(amdOptimize("backbone",{
            paths :
                'underscore': 'js/libs/underscore'
                "backbone"  : "js/libs/backbone"
                "jquery"    : "js/libs/jquery"
            optimize: 'uglify2'
            optimizeCss: 'none'
            fileExclusionRegExp: /(?:^\.)|(?:\.coffee$)|(?:\.s[ac]ss$)|(?:\.iml$)/
            removeCombined: true
            findNestedDependencies: true
            include: [
                'underscore'
                'jquery'
                'backbone'
            ]
            shim:
                'underscore':
                    exports: '_'
                'backbone':
                    deps: [ 'underscore', 'jquery' ]
                    exports: 'Backbone'
        }))
        .pipe(concat("core.js"))
        .pipe(gulp.dest("../assets"))

gulp.task 'default', ["scripts:player", "scripts:core"], ->
    gulp.watch(['coffee/*.coffee'],[
        "scripts:player"
    ]);
    gulp.watch(['js/libs/*.js'],[
        "scripts:core"
    ]);