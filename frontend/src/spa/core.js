/**
 *  Core module
 */
define(['cs!./common/index'], function (module) {
    module.config(['$locationProvider', function ($locationProvider) {
            $locationProvider.html5Mode({
                enabled: true,
                requireBase: false
            });
        }]);
    module.run(['$rootScope', '$location', '$window', function ($rootScope, $location, $window) {
            // somewhere else
            $rootScope.$on('$stateNotFound',
                    function (event, unfoundState, fromState, fromParams) {
                        console.log(unfoundState.to, unfoundState.to.replace(/\.+/g, "/"));
                        console.log(unfoundState.toParams);
                        console.log(unfoundState.options); // {inherit:false} + default options
                        event.preventDefault();
                        $window.location = unfoundState.to.replace(/\.+/g, "/");
                    });
        }]);
//    module.run(['$location','$window','$state',function($location,$window,$state){
//           $location.url('/asdf');
//            console.log('go home');
//            $window.$state = $state;
//            $window.$location = $location;
//            
//    }])
//    module.config(['$urlRouterProvider', function ($urlRouterProvider) {
//            
//            $urlRouterProvider.rule(function ($injector, $location) {
//             
//                var path = $location.path();
//                   console.log('rule path',path);
//                if(path=='/' && !$injector.get('CurrentUserService').user().role  ){
//                    alert($injector.get('CurrentUserService').user().role);
//                }
//            });
//            $urlRouterProvider.otherwise(function ($injector, $location) {
//                console.log($injector.get('$state').$current); //.go('anon.login');
//                console.log($location.url());
//                console.log($injector.get('CurrentUserService').user().role)
//                _role = $injector.get('CurrentUserService').user().role;
//
//                if (_role === 'Administrator') {
//                    $injector.get('$state').go('user.management')
//                } else {
//                    if (_role === 'Operator') {
//                        $injector.get('$state').go('user.chatroom')
//                        //$location.url('/chatroom');
//                    }
//                }
//                if (!_role) {
//                    //$location.url('/login');
//                    $injector.get('$state').go('anon.login');
//                }
// 
//              
//
//            });
//        }]);
    module.factory('LocalService', [function () {
            return {
                get: function (key) {
                    return localStorage.getItem(key);
                },
                set: function (key, val) {
                    return localStorage.setItem(key, val);
                },
                unset: function (key) {
                    return localStorage.removeItem(key);
                }
            }
        }]);
    module.factory('CurrentUserService', ["LocalService", function (LocalService) {
            return {
                user: function () {
                    if (LocalService.get('auth_token')) {
                        return angular.fromJson(LocalService.get('auth_token')).user;
                    } else {
                        return {};
                    }
                }
            }
        }]);
    module.controller('NavController', ["$scope", "Auth", "CurrentUserService", "$location", function ($scope, Auth, CurrentUser, $location) {

            $scope.isCollapsed = true;
            $scope.auth = Auth;
            $scope.user = CurrentUser.user;

            $scope.logout = function () {
                Auth.logout().success(function (result) {
                    $location.url('');
                });
            };

            $scope.getApiKey = function () {
                Auth.apikey().success(function (result) {
                    console.log(result);
                    //alert('Api key');
                    prompt("API key", result.key);
                });
            };
        }]);
    module.controller('LoginController', ["$scope", "$state", "Auth", 'CurrentUserService', '$location', function ($scope, $state, Auth, CurrentUser, $location) {
            $scope.errors = [];
            //$scope.user = CurrentUser.user;
            $scope.login = function () {
                $scope.errors = [];
                Auth.login($scope.user).success(function (result) {
                    //$state.go('user.home');
                    if (CurrentUser.user().role === 'Administrator') {
                        $location.url('/management/operators');
                    } else {
                        $state.go('chatroom');
                    }
                }).error(function (err) {
                    $scope.errors.push(err);
                });
            };
        }]);
    //    module.factory('CountriesFactory',['$http', function($http){
    //        return {
    //            list: _l
    //            
    //        }
    //            
    //    }
    //    ]

    //        )
    module.controller('RegisterController', ["$scope", "$state", "Auth", "$http", "$log", function ($scope, $state, Auth, $http, $log) {
            //TODO: delete on production
            $scope.isBusy = true;
            $scope.errors = [];
            $scope.user = {
                companyname: '', //"Demo Company (at " + (new Date()).toISOString()+")",
                email: '', // 'demo@demo.com',
                isoCountry: "US",
                firstname: '', //"Demo First Name (at " + (new Date()).toISOString()+")",
                lastname: '', //"Demo Last Name (at " + (new Date()).toISOString()+")",
                password: '', //"demo123456",
                confirmPassword: '', //"demo123456",
                phone: '', // "+19999999",
                role: "Administrator"
            };
            // ISO,Country,
            $scope.countryList = [];
            $http.get('/countries.json').then(function (result) {
                $scope.isBusy = false;
                $scope.countryList = result.data;
            });

            $scope.register = function () {
                $scope.isBusy = true;
                Auth.register($scope.user).then(
                        function (data) {
                            $scope.isBusy = false;
                            $state.go('anon.activate');
                        },
                        function (data) {
                            $scope.isBusy = false;
                            $log.info(data, $scope.errors);
                            $scope.errors = [data.data];
                            $log.info($scope.errors);
                        }
                );
            };

        }]);
    //
    module.constant('AccessLevels', {
        anon: 0,
        user: 1,
        administrator: 2
    });

    module.constant('baseUrl', '/api/v1');

    module.factory('Auth', ['$http', 'LocalService', 'AccessLevels', '$location', function ($http, LocalService, AccessLevels, $location) {
            return {
                authorize: function (access) {
                    if (access === AccessLevels.user) {
                        return this.isAuthenticated();
                    } else {
                        return true;
                    }
                },
                isAuthenticated: function () {
                    return LocalService.get('auth_token');
                },
                login: function (credentials) {
                    var login = $http.post('/api/v1/auth/authenticate', credentials);
                    login.success(function (result) {
                        LocalService.set('auth_token', JSON.stringify(result));
                    });
                    return login;
                },
                logout: function () {
                    // We must inform server 
                    console.log(this.isAuthenticated());
                    var register = $http.post('/api/v1/auth/logout', angular.fromJson(LocalService.get('auth_token')).user);
                    register.success(function (result) {
                        LocalService.unset('auth_token');
                    });
                    return register;
                },
                register: function (formData) {
                    LocalService.unset('auth_token');
                    var register = $http.post('/api/v1/auth/register', formData);
                    register.success(function (result) {
                        //$location.url('/')    
                        //LocalService.set('auth_token', JSON.stringify(result));
                    });
                    return register;
                },
                activate: function (formData) {
                    LocalService.unset('auth_token');
                    var activate = $http.put('/api/v1/auth/activate/' + formData.apiKey, formData);
                    activate.success(function (result) {
                        //$location.url('/')   
                        LocalService.unset('auth_token');
                        LocalService.set('auth_token', JSON.stringify(result));
                    });
                    return activate;
                },
                apikey: function () {
                    var apikey = $http.get('/api/v1/apikey/' + angular.fromJson(LocalService.get('auth_token')).user.id);
                    apikey.success(function (result) {
                        console.log(result);
                    });
                    return apikey;
                },
                updatepassword: function (credentials) {
                    var updatepassword = $http.put('/api/v1/auth/updatepassword', credentials);
                    updatepassword.success(function (result) {
                        LocalService.set('auth_token', JSON.stringify(result));
                    });
                    return updatepassword;
                }
            }
        }])
            .factory('AuthInterceptor', ["$q", "$injector", function ($q, $injector) {
                    var LocalService = $injector.get('LocalService');
                    return {
                        request: function (config) {
                            var token;
                            if (LocalService.get('auth_token')) {
                                token = angular.fromJson(LocalService.get('auth_token')).token;
                            }
                            if (token) {
                                config.headers.Authorization = 'Bearer ' + token;
                            }
                            return config;
                        },
                        responseError: function (response) {
                            if (response.status === 401 || response.status === 403) {
                                LocalService.unset('auth_token');
                                $injector.get('$state').go('anon.login');
                            }
                            return $q.reject(response);
                        }
                    }
                }])
            .config(["$httpProvider", function ($httpProvider) {
                    $httpProvider.interceptors.push('AuthInterceptor');
                    //$sailsSocketProvider.interceptors.push('mySocketInterceptor');http://balderdashy.github.io/angularSails/#/api/ngsails.$sailsSocket
                }]);
    //======================Controllers

    module.directive("compareTo", [function () {
            return {
                require: "ngModel",
                scope: {
                    otherModelValue: "=compareTo"
                },
                link: function (scope, element, attributes, ngModel) {

                    ngModel.$validators.compareTo = function (modelValue) {
                        return modelValue == scope.otherModelValue;
                    };

                    scope.$watch("otherModelValue", function () {
                        ngModel.$validate();
                    });
                }
            };
        }]);
    return module;
});