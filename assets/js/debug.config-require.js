/**
 * Configuration RequireJS 
 */
if (typeof define !== 'function') {
    // to be able to require file from node
    var define = require('amdefine')(module);
}
//window.name = 'NG_DEFER_BOOTSTRAP!';
define({
    // Here paths are set relative to `/source/js` folder
    baseUrl: "/src", 
    paths: {
        'cs': './../../vendors/require-cs/cs',
        'coffee-script': '../../vendors/coffeescript/extras/coffee-script',
        'text': '../../vendors/requirejs-text/text',
        'tpl':'../../vendors/requirejs-tpl/tpl',
        'angular': '../../vendors/angular/angular', //"https://ajax.googleapis.com/ajax/libs/angularjs/1.3.0/angular.min",
        'angular-animate': '../../vendors/angular-animate/angular-animate',
        //'angular': '//ajax.googleapis.com/ajax/libs/angularjs/1.2.16/angular',
        'angular-resource': '../../vendors/angular-resource/angular-resource',
        'angular-sails': '../../vendors/angular-sails/dist/angular-sails',
        'angular-ui-router': '../../vendors/angular-ui-router/release/angular-ui-router',
        'angular-ui-router.stateHalper': '../../vendors/angular-ui-router.stateHelper/statehelper',
        'angular-bootstrap': '../../vendors/angular-bootstrap/ui-bootstrap-tpls.min',
        'domReady': './../../vendors/domReady/domReady', 
        'io_logger': 'http://newspaper-plan.cloudapp.net:1337/js/io_logger', //'http://127.0.0.1:1337/js/io_logger',
        'ng-table': '../../vendors/ng-table/ng-table',
        'angularjs-toaster': '../../vendors/angularjs-toaster/toaster',
        'angular-dialog-service': '../../vendors/angular-dialog-service/dist/dialogs.min',
        'angular-translate': '../../vendors/angular-translate/angular-translate',
        'angular-sanitize': '../../vendors/angular-sanitize/angular-sanitize',
        'dialogs-translation': '../../vendors/angular-dialog-service/dist/dialogs-default-translations.min',
        'lodash': '../../vendors/lodash/dist/lodash',
        'angular-local-storage': '../../vendors/angular-local-storage/dist/angular-local-storage',
        'angular-bootstrap-colorpicker': '../../vendors/angular-bootstrap-colorpicker/js/bootstrap-colorpicker-module',
        'd3': '../../vendors/d3/d3.min',
        'angular-sails-bind': '../../vendors/angular-sails-bind/dist/angular-sails-bind', 
        ///SAILS  config https://github.com/balderdashy/angularSails/blob/master/example/assets/index.html
        'socketio': '//cdnjs.cloudflare.com/ajax/libs/socket.io/0.9.16/socket.io.min',//'http://127.0.0.1:3000/socket.io/socket.io',
        'sails.io':'../..//vendors/sails.io.js/sails.io',//Sails v10.5 ## Will need Use version without socketIO
        'ngsails.io': '../../vendors/angularSails/dist/ngsails.io'
    },
    shim: {
        'angular': {
            'exports': 'angular',
            deps: ['lodash']
        }, 
        'lodash': {
            exports: ['_']
        },
        'angular-resource': {
            deps: ['angular']
        },
        'angular-animate': {
            deps: ['angular']
        },
        'angular-sails': {
            deps: ['sails.io', 'angular']
        },
        'angular-ui-router': {
            deps: ['angular']
        },
        'angular-ui-router.stateHalper': {
            deps: ['angular-ui-router']
        },
        'angular-bootstrap': {
            deps: ['angular']
        },
        'ng-table': {
            deps: ['angular']
        },
        
        'angularjs-toaster': {
            deps: ['angular','angular-animate']
        },
        'jQuery': {
            'exports': 'jQuery'
        },
        'socketio': {
            'exports': 'io'
        },
        // Sails 10.~ socket io
        'ngsails.io': {
            'deps': ['sails.io','angular']   ,  
            'exports': 'io'
        },        
        
        'sails.io': {
           'deps': ['socketio'],
           'exports': 'io'
        }, 
        'angular-dialog-service': {
            deps: ['angular', 'angular-sanitize', 'dialogs-translation']
        },
        'angular-translate': {
            deps: ['angular']
        },
        'angular-sanitize': {
            deps: ['angular']
        },
        'dialogs-translation': {
            deps: ['angular', 'angular-translate']
        },
        'angular-local-storage': {
            deps: ['angular']
        },
        'angular-bootstrap-colorpicker': {
            deps: ['angular']
        },
        'd3': {
            'exports': 'd3'
        },
        'angular-sails-bind': {
            deps: ['angular', 'sails.io']
        }, 
    }
   ,deps:[ 'sails.io','ngsails.io', 'angular-bootstrap','angular-ui-router','angular-animate' ]//http://www.startersquad.com/angularjs-requirejs/
});

