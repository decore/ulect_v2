/**
 * Configuration RequireJS 
 */
requirejs.config({
    // Here paths are set relative to `/source/js` folder
    baseUrl: "/js/spi",
    paths: {
        'cs': './../../vendors/require-cs/cs',
        'coffee-script': '../../vendors/coffeescript/extras/coffee-script',
        'text': '../../vendors/requirejs-text/text',
        'tpl': '../../vendors/requirejs-tpl/tpl',
        'angular': '../../vendors/angular/angular.min', //"https://ajax.googleapis.com/ajax/libs/angularjs/1.3.0/angular.min",
        'angular-animate': '../../vendors/angular-animate/angular-animate.min',
        "angular-messages": '../../vendors/angular-messages/angular-messages',
        'angular-resource': '../../vendors/angular-resource/angular-resource.min',
        'angular-ui-router': '../../vendors/angular-ui-router/release/angular-ui-router.min',
        //'angular-ui-router.stateHalper': '../../vendors/angular-ui-router.stateHelper/statehelper',
        'angular-bootstrap': '../../vendors/angular-bootstrap/ui-bootstrap-tpls.min',
        'domReady': './../../vendors/domReady/domReady',
        'ng-table': '../../vendors/ng-table/ng-table',
        'angularjs-toaster': '../../vendors/angularjs-toaster/toaster',
        'angular-dialog-service': '../../vendors/angular-dialog-service/dist/dialogs.min',
        'angular-translate': '../../vendors/angular-translate/angular-translate',
        'angular-sanitize': '../../vendors/angular-sanitize/angular-sanitize',
        'dialogs-translation': '../../vendors/angular-dialog-service/dist/dialogs-default-translations.min',
        'lodash': '../../vendors/lodash/dist/lodash',
        'sails-io': '../..//vendors/sails.io.js/sails.io', //Sails v10.5 ## Will need Use version without socketIO
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
        "angular-messages": {
            deps: ['angular']
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
            deps: ['angular', 'angular-animate']
        },
        // Sails 10.~ socket io ng Module
        'ngsails.io': {
            'deps': ['sails-io', 'angular'],
        },
        'sails-io': {// Sails 10. SDK
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
        }
    }
});


