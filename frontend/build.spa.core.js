/** 
 *  configuration for build production version
 *  NOTE: for run production build execute command $node r.js -o build_one_file.js
 */
({
    baseUrl: "./src/spa",
    mainConfigFile: "./src/main.config.js",
//    paths: {
//        'page': 'chatroom'
//    },
    CoffeeScript: {
        bare: false
    },
    modules: [
        //Just specifying a module name means that module will be converted into
        //a built file that contains all of its dependencies. If that module or any
        //of its dependencies includes i18n bundles, they may not be included in the
        //built file unless the locale: section is set above.
//        {
//            name: "foo/bar/bop",
//
//            //create: true can be used to create the module layer at the given
//            //name, if it does not already exist in the source location. If
//            //there is a module at the source location with this name, then
//            //create: true is superfluous.
//            create: true,
//
//            //For build profiles that contain more than one modules entry,
//            //allow overrides for the properties that set for the whole build,
//            //for example a different set of pragmas for this module.
//            //The override's value is an object that can
//            //contain any of the other build options in this file.
//            override: {
//                pragmas: {
//                    fooExclude: true
//                }
//            }
//        },
         {
            name: "debug",
            exclude: [
                'lodash',
                'angular',
                'coffee-script'
            ],
            stubModules: ['text', 'tpl','cs'],
            findNestedDependencies: true,
            insertRequire: ['../bootstrap_app'],
        },
        
    ],   
//       removeCombined: true,
    exclude: ['coffee-script'],
    stubModules: ['text', 'tpl','cs'],
    findNestedDependencies: true,
    //name: 'core',
    //include: [ 'angular' ,'core'],
    //wrap: true,
    wrap: {
        startFile: "built/start.frag",
        endFile: "built/end.frag"
    },
    //out: './js/spa/core.js'
     dir: './js/spa'
    //out: './../../.tmp/public/js/spacore.js'
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
