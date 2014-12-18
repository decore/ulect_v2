/** 
 *  configuration for build production version
 *  NOTE: for run production build execute command $node r.js -o build_one_file.js
 */
({
    baseUrl: "./js/spi",
    mainConfigFile: "./js/main.config.js",
    paths: {
        'page': 'chatroom'
    },
    CoffeeScript: {
        bare: true
    },
    exclude: ['coffee-script', 'socketio'],
    stubModules: ['text', 'cs'],
    findNestedDependencies: true,
    name: '../bootstrap_app',
    include: [ 'angular','core' ],
   wrap: false,
//    wrap: {
//        startFile: "built/start.frag",
//        endFile: "built/end.frag"
//    },
    out: './js/spa/chatroom.js'
    , optimize: 'none'
    , uglify2: {
        'screw-ie8': true,
        compress: {
            global_defs: {
                DEBUG: false
            }
        },
        warnings: false,
        // Safe here, probably due to implicit declarations in r.js
        mangle: true
    }
})
