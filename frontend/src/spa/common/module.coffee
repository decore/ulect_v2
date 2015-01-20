###
module and class dependecies
### 
define  [
    'angular'
    'cs!./namespaces'
    'cs!dialogService/index'
    'cs!./loadingContainer/index'
    'angular-ui-router'
    ] ,(
    angular
    namespaces
    dialogService
    loadingContainerModule
)->

    module =  angular.module namespaces.name,['ui.router','ngAnimate',  'ngResource', 'ngMessages','ui.bootstrap',dialogService,loadingContainerModule]
    module.config ["$stateProvider", "$urlRouterProvider", "AccessLevels", ($stateProvider, $urlRouterProvider, AccessLevels) ->
        $stateProvider.state("anon",
            abstract: true
            template: "<ui-view/>"
            data:
                access: AccessLevels.anon
        ).state("anon.home",
            url: "/home"
            templateUrl: "templates/#{module.name.replace /\.+/g, "/"}/home.tpl.html"#"home.html"
        ).state("anon.login",
            url: "/login"
            templateUrl:"templates/#{module.name.replace /\.+/g, "/"}/auth/login.tpl.html"# "auth/login.html"
            controller: "LoginController"
        ).state( "anon.register",
            url: "/register"
            templateUrl: "templates/#{module.name.replace /\.+/g, "/"}/auth/register.tpl.html"#"auth/register.html"
            controller: "RegisterController")
        .state( "anon.activate",
            url: "/activate"
            templateUrl: "templates/#{module.name.replace /\.+/g, "/"}/auth/activate.tpl.html"
            controller: "ActivateController")
        .state( "anon.apply",
            url: "/activate/:apiKey?token"
            templateUrl: "templates/#{module.name.replace /\.+/g, "/"}/auth/activate.tpl.html"
            controller: "ActivateController")

        .state( "anon.password",
            #url: "/password?email"
            abstract: true
            templateUrl: "templates/#{module.name.replace /\.+/g, "/"}/password/index.tpl.html"
            controller: "ResetController"
            ## add controll access
        ).state( "anon.password.reset",
            url: "/reset-password"
            templateUrl: "templates/#{module.name.replace /\.+/g, "/"}/password/reset.tpl.html"
            #controller: "ResetController"
        ).state( "anon.password.verification",
            url: "/reset-verification?token"
            templateUrl: "templates/#{module.name.replace /\.+/g, "/"}/password/verification.tpl.html"
            #controller: "ResetController"
        )

            #            $stateProvider.state("user",
            #                abstract: true
            #                template: "<ui-view/>"
            #                data:
            #                    access: AccessLevels.user
            #            ).state "user.profile",
            #                url: "/profile"
            #                templateUrl: "user/profile.tpl.html"
            #                controller: "MessagesController"

        #$urlRouterProvider.otherwise "/"
        return
    ]

    module.controller 'ActivateController', ['$scope','$stateParams','$http',"Auth","$log",($scope,$stateParams,$http, Auth,$log)->
        apiURL = '/api/v1'
        $scope.stateActivation = ''

        $scope.errors = []
        $scope.messages = []
        init = =>
            if $stateParams.apiKey? and $stateParams.token?
                # //$location.url('/')
                $scope.stateActivation = ''
                $scope.isBusy = true
                Auth.activate(apiKey:$stateParams.apiKey,token:$stateParams.token).then(
                    (result)->
                        $scope.messages = [result.data]
                        $scope.stateActivation = 'success'
                        #$location.url('/')
                    (err)->
                        $scope.errors = [ err.data ]
                        $scope.stateActivation = 'error'
                ).finally(
                    ()->
                        $scope.isBusy = false
                )

            else
                $scope.stateActivation = 'info'
                $scope.isBusy = false
        init()
    ]
    ## Reset controller
    module.controller 'ResetController', ['$scope','$state','$stateParams','$http','$location','$log','Auth',($scope,$state,$stateParams,$http,$location,$log,Auth)->
        apiURL = '/api/v1'
        token = $state.params.token
        $log.info $stateParams,$state
        $scope.isBusy = false
        $scope.user =
            password: ""
            passwordConfirm:""
        $scope.message = null

        $scope.onTest = ()->
            console.log "data"
        ## on send email
        $scope.onSendInstruction = (event,email)->
            event.preventDefault() if event
            $scope.message = null
            $scope.isBusy = true
            $http.post(apiURL+'/auth/forgotpassword',email:email).then(
                (result)->
                    $log.info result
                    console.log result
                    $scope.message =
                        text: result.data.user_msg
                        status: 'alert-success'
                    $scope.isBusy = false
                    #$location.url ''
                (err)->
                    $scope.message =
                        text: err.data.user_msg
                        status: 'alert-danger'
                    $scope.isBusy = false

            )
            return
        ## change password
        $scope.onSetNewPassword = (event,data)->
            data.token = token
            $log.info "data",data
            event.preventDefault() if event
            $scope.isBusy = true
            Auth.updatepassword(data).then(
                (result)->
                    $location.url('/')
                    return
                (err)->

            ).finally(
                ->
                    $scope.isBusy = false
            )
            return

    ]


    return module