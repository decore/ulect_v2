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
        #RF06 - User can change password
        $stateProvider.state statespace.name+'.profile',
            url: '/profile'
            templateUrl: "templates/#{namespace.replace /\.+/g, "/"}/profile.tpl.html"
            data:
                pageTitle: statespace.pageTitle
            controller: ["$scope","$modal","$http","CurrentUserService",($scope,$modal,$http,CurrentUserService)->
                apiURL = '/api/v1'
                currentUser = CurrentUserService.user
                $scope.profile = {}
                $http.get('/api/v1/account/profile/'+currentUser().id).then(
                    (result)->
                        $scope.profile =  result.data
                        return true
                    (err)->
                        $scope.profile = {}
                        return false
                )
                $scope.onChangePassword = (_event)->
                    _event.preventDefault()
                    $modal.open(
                        windowClass: 'addModal'
                        templateUrl: "templates/#{namespace.replace /\.+/g, "/"}/form.changepassword.tpl.html"
                        controller: ['$scope','$modalInstance',($scope,$modalInstance)->
                            $scope.editEntity =
                                password : ""
                            $scope.onCancel = ->
                                $modalInstance.dismiss('cancel')
                            $scope.onSave = (_event,data)->
                                _event.preventDefault() if _event
                                $scope.isBusy = true
                                $http.put(apiURL+'/account/changepassword',data).then(
                                    (result)->
                                        $modalInstance.close()
                                    (err)->
                                       $scope.isBusy = false
                                       if err.data?.user_msg?
                                        $scope.message =
                                            text : err.data.user_msg
                                            status: 'label-danger'
                                        #$modalInstance.dismiss()
                                )
                        ]
                    )
                $scope.onSave = (_event,data)->
                    $scope.isBusy = true
                    $http.put('/api/v1/account/profile/'+currentUser().id,data).then(
                        (result)->
                            $scope.profile
                            console.log result
                            $scope.isBusy = false
                        (err)->
                            $scope.user = {}
                            $scope.isBusy = false
                    )
            ]



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
