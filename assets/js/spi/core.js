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
    module.controller('NavController', ["$scope", "Auth", "CurrentUserService", function ($scope, Auth, CurrentUser) {

            $scope.isCollapsed = true;
            $scope.auth = Auth;
            $scope.user = CurrentUser.user;

            $scope.logout = function () {
                Auth.logout();
            };
        }]);


    module.controller('LoginController', function ($scope, $state, Auth) {
        $scope.errors = [];

        $scope.login = function () {
            $scope.errors = [];
            Auth.login($scope.user).success(function (result) {
                $state.go('user.messages');
            }).error(function (err) {
                $scope.errors.push(err);
            });
        }
    });
    //
    module.constant('AccessLevels', {
        anon: 0,
        user: 1
    });
  
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
                // The backend doesn't care about logouts, delete the token and you're good to go.
                LocalService.unset('auth_token');
            },
            register: function (formData) {
                LocalService.unset('auth_token');
                var register = $http.post('/auth/register', formData);
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