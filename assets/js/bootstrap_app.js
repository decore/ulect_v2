/**
 * bootstraps angular onto the window.document node
 * 
 */
define(['domReady!', 'angular', 'app', 'angularjs-toaster', 'angular-resource', 'sails.io'], function (document, ng, app) {
    'use strict';
    var app_init = ng.module('spaApp', [app['name'], 'ngAnimate', 'toaster', 'ngResource', 'sails.io']); 
    app_init.factory('NotificationService', [
        'toaster', function (toaster) {
            return {
                error: function (title, text, settings) {
                    if (settings == null) {
                        settings = null;
                    }
                    return toaster.pop('error', title, text);
                },
                info: function (title, text, settings) {
                    if (settings == null) {
                        settings = null;
                    }
                    return toaster.pop('info', title, text);
                },
                wait: function (title, text, settings) {
                    if (settings == null) {
                        settings = null;
                    }
                    return toaster.pop('wait', title, text);
                },
                success: function (title, text, settings) {
                    if (title == null) {
                        title = "Success";
                    }
                    if (settings == null) {
                        settings = null;
                    }
                    return toaster.pop('success', title, text);
                },
                warning: function (title, text, settings) {
                    if (settings == null) {
                        settings = null;
                    }
                    return toaster.pop('warning', title, text);
                },
                getToaster: toaster
            };
        }
    ]);
    /***
     * Page title changes
     */
    app_init.run([
        '$rootScope', 'NotificationService', function ($rootScope, NotificationService) {
            $rootScope.$on('$stateChangeSuccess', function (event, toState, toParams, fromState, fromParams) {
                $rootScope.pageTitle = 'Служба поддержки';
                if (angular.isDefined(toState.data)) {
                    if (angular.isDefined(toState.data.pageTitle)) {
                        return $rootScope.pageTitle = toState.data.pageTitle + ' | Служба поддержки';
                    }
                }
            });
            $rootScope.$on('$stateChangeError', function (event, toState, toParams, fromState, fromParams, error) {
//                   event.preventDefault()
                console.log(error);
                if (!!error.message) {
                    NotificationService.error("Server error", error.message);
                }
            });
            return console.info('run ');
        }
    ]);
    app_init.config(['$httpProvider', function ($httpProvider) {
            return $httpProvider.interceptors.push([
                '$q', '$window', 'NotificationService', function ($q, $window, NotificationService) {
                    return {
                        response: function (response) {
                            if (response.status === 500) {
                                NotificationService.error("Server error", response.data.message);
                                
                            }
                            return response || $q.when(response);
                        },
                        responseError: function (rejection) {
                            var _ref, _ref1, _ref2;
                               
                            if (rejection.statusText === "Internal Server Error"){
                                  NotificationService.error("Server error", "Сбой в работе сервера");
                            }
                            if (rejection.status === 500 || rejection.status === 400 || rejection.status === 401) {
                                //console.log("Response Error 500,400,401", rejection);
                                if (((_ref = rejection.data) != null ? _ref.summary : void 0) != null) {
                                    NotificationService.error("Server error", rejection.data.summary);
                                }
                                if (((_ref1 = rejection.data) != null ? _ref1.error : void 0) != null) {
                                    NotificationService.error("Server error", rejection.data.error);
                                }
                                if (((_ref2 = rejection.data) != null ? _ref2.msg : void 0) != null) {
                                    NotificationService.error("Server error", rejection.data.msg);
                                    //$location.path('/login');
                                    //$window.location.reload(); // redirect to login page
                                    $window.location = '/login/';
                                }
                            }
                            return $q.reject(rejection);
                        }
                    };
                }
            ]);
        }]);
    app_init.config(['$locationProvider', function ($locationProvider) {
            $locationProvider.html5Mode(true);
        }]); 
    /***
     * 
     */
    app_init.directive('enterSubmit', function () {
        return {
            restrict: 'A',
            link: function (scope, elem, attrs) {

                elem.bind('keydown', function (event) {
                    var code = event.keyCode || event.which;

                    if (code === 13) {
                        if (!event.shiftKey) {
                            event.preventDefault();
                            scope.$apply(attrs.enterSubmit);
                        }
                    }
                });
            }
        }
    });
    ng.bootstrap(document.getElementsByTagName('html'), [app_init['name'],
        function () {
            console.info('The following is required if you want AngularJS Scenario tests to work');
            // The following is required if you want AngularJS Scenario tests to work
            //ng.element(document).find('html').addClass('ng-app: ' + app_init['name']);
            //document.getElementsByTagName('html').addClass('ng-app'); 
            // return ng;
        }
    ]);
    ng.resumeBootstrap(); //https://docs.angularjs.org/guide/bootstrap & http://stackoverflow.com/questions/25668958/angular-is-missing-resumebootstrap-function

});
