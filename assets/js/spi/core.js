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
        }]);
    module.controller('LoginController', ["$scope", "$state", "Auth", function ($scope, $state, Auth) {
            $scope.errors = [];
            $scope.login = function () {
                $scope.errors = [];
                Auth.login($scope.user).success(function (result) {
                    //$state.go('user.home');
                    $state.go('chatroom');
                }).error(function (err) {
                    $scope.errors.push(err);
                });
            }
        }]);
    module.controller('RegisterController', ["$scope", "$state", "Auth", function ($scope, $state, Auth) {
            //TODO: delete on production
            $scope.user = {
                companyname: "Demo Company (at " + (new Date()).toISOString()+")",
                email: 'demo@demo.com',
                country: "US",
                firstname: "Demo First Name (at " + (new Date()).toISOString()+")",
                lastname: "Demo Last Name (at " + (new Date()).toISOString()+")",
                password: "demo123456",
                confirmPassword: "demo123456",
                phone: "+19999999"
            }
            $scope.register = function () {
                Auth.register($scope.user).then(function (data) { 
                    $state.go('anon.home'); 
                });
            }
        }]);
    //
    module.constant('AccessLevels', {
        anon: 0,
        user: 1
    });
   
    module.constant('baseUrl', '/api/v1');    
    
    module.factory('Auth', function ($http, LocalService, AccessLevels) {
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
                    LocalService.set('auth_token', JSON.stringify(result));
                });
                return register;
            }
        }
    })
            .factory('AuthInterceptor', function ($q, $injector) {
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
            })
            .config(function ($httpProvider) {
                $httpProvider.interceptors.push('AuthInterceptor');
            });
    //======================Controllers


    return module;
});