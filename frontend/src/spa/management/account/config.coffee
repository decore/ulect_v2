###
Module configuration
###
define [
    'cs!./namespace'
    'cs!./module'
    'cs!./statespace' ## Configuration for ui-route state
], (namespace, module, statespace)->
    module.config ['$stateProvider', '$urlRouterProvider',($stateProvider,$urlRouterProvider)->
        ###
        Main configuration $stateProvider
        ###
        console.log  statespace.url
        $urlRouterProvider.when(statespace.url,statespace.url+'.profile')
        $stateProvider.state statespace.name,
            url: statespace.url
            abstract: true
            template: "<ui-view>"
            data:
                pageTitle: statespace.pageTitle

        $stateProvider.state statespace.name+'.profile',
            url: '/profile'
            templateUrl: "templates/#{namespace.replace /\.+/g, "/"}/profile.tpl.html"
            data:
                pageTitle: statespace.pageTitle
        $stateProvider.state statespace.name+'.settings',
            url: '/settings'
            templateUrl: "templates/#{namespace.replace /\.+/g, "/"}/settings.tpl.html"

            controller: [ '$scope','$http','baseUrl',($scope,$http,baseUrl)->
                $scope.settings = {}
                $scope.isBusy = true
                $http.get(baseUrl+'/account/settings').then(
                    (result)->
                        $scope.settings = result.data
                    (err)->
                        $scope.settings =
                            AR1: 'Hello, welcome to our support center. Operator will contact you shortly.'
                            AR2: 'Please keep waiting. Our operator will contact you shortly'
                        return
                ).finally(
                    ()->
                        $scope.isBusy = false
                )
                $scope.onSaveSettingA1 = (event,AR1)->
                    console.log AR1
                    event.preventDefault()
                    $scope.isBusy1 = true
                    $http.put(baseUrl+'/account/settings/AR1',value:AR1).then(
                        (result)->
                            console.log result
                            $scope.settings.A1 = result.A1

                        (err)->
                            return
                    ).finally(
                        ()->
                            $scope.isBusy1 = false
                    )
                $scope.onSaveSettingA2 = (event,AR2)->
                    console.log AR2
                    event.preventDefault()
                    $scope.isBusy2 = true
                    $http.put(baseUrl+'/account/settings/AR2',value:AR2).then(
                        (result)->
                            console.log result
                            $scope.settings.A2 = result.A2
                        (err)->
                            return
                    ).finally(
                        ()->
                            $scope.isBusy2 = false
                    )
            ]
            data:
                pageTitle: statespace.pageTitle
    ]
