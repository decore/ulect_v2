###
DialogService
###
define [
    'cs!./module'
    'cs!./namespace'
    'angular-dialog-service'
], (module, namespace) ->
    module.controller('instructionDialogController', ['$scope', '$modalInstance', '$templateCache', 'data',
        ($scope, $modalInstance, $templateCache, data)->
            header = data.header
            msg = data.msg


            endsWith = (str, suffix) ->
                str.indexOf(suffix, str.length - suffix.length) != -1

            ### Scope Variables ###
            $scope.header = if (angular.isDefined(header)) then  header else ''
            $scope.msg = if (angular.isDefined(msg))
                if endsWith(msg, 'html') then $templateCache.get(msg) else msg
            else ''

            ### Methods ###
            $scope.close = () ->
                $modalInstance.close()
                #$scope.$destroy()
    ])
    .controller('deleteDialogController', ['$scope', '$modalInstance', 'data',
            ($scope, $modalInstance, data)->
                header = data.header
                msg = data.msg

                ### Scope Variables ###
                $scope.header = if (angular.isDefined(header)) then  header else ''
                $scope.msg = if (angular.isDefined(msg)) then msg else ''

                ### Methods ###
                $scope.yes = () ->
                    $modalInstance.close('yes')
                    $scope.$destroy()

                $scope.no = () ->
                    $modalInstance.dismiss('no')
                    $scope.$destroy()
        ])

    module.factory 'DialogService', [
        'dialogs'
        (dialogsMain) ->
            error: dialogsMain.error

            wait: dialogsMain.wait

            notify: dialogsMain.notify

            confirm: dialogsMain.confirm

            create: dialogsMain.create

            ###
            Relevano custom dialogs ##start
            ###

            instructionDialog: (header, msg, opts = null) ->
                data =
                    header: header
                    msg: msg
                dialogsMain.create("templates/#{namespace.replace /\.+/g, "/"}/instructionDialogTemplate.tpl.html",
                    'instructionDialogController', data)

            deleteDialog: (header, msg, opts = null) ->
                data =
                    header: header
                    msg: msg
                dialogsMain.create("templates/#{namespace.replace /\.+/g, "/"}/deleteDialogTemplate.tpl.html",
                    'deleteDialogController', data)

            ###
            Relevano custom dialogs ##end
            ###

            getDialogsMain: dialogsMain
    ]