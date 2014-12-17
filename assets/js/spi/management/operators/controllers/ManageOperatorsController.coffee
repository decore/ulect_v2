###* ManageUsersController ###
define ['cs!./../module','cs!./../namespace'],(module,namespace)->
    module.controller 'ManageOperatorsController',[
        '$scope'
        '$filter'
        '$modal'
        'APIService'
        'DialogService'
        'ngTableParams'
        ($scope, $filter,$modal,APIService,DialogService, ngTableParams)->
            ###
            Create ngTableParams
            ###
            $scope.tableParams = new ngTableParams
                page: 1
                count: 10
                sorting:
                    id: 'asc'  # special settings for this table
            ,
                total: 0, # length of data
                getData: ($defer, params)->
                    paramSend =
                        sort: params.sorting()#orderBy()#.join()
                        limit: params.count()
                        page: params.page()
                    _.extend paramSend , angular.copy params.filter()
                    APIService.query( paramSend,
                        (result,p)->
                            # update table params
                            params.total(p()['x-prism-total-items-count'])
                            #set new data
                            $defer.resolve result
                        (result)->
                            $defer.resolve()# resolve

                    )
                $scope: $scope.$new()
            ###* confirm delete (used service) ###
            $scope.onDeleteUser = (item)->
                delDlg = DialogService.deleteDialog "Delete User","Are you sure you want to delete selected <strong>#{item.userName}</strong>?"
                delDlg.result.then(
                    ##confirn delete entity
                    (res)->
                        $scope.isBusy = true
                        item.$delete().then(
                            (result)->
                                $scope.isBusy = false
                                $scope.tableParams.reload()
                                $modalInstance.close(null)
                            (error)->
                                $scope.isBusy = false
                        )
                )
            ###* Add new User or Edit them in modal window###
            $scope.onEditUser = $scope.onAddUser = (item = null)->
                console.log item
                $modal.open(
                    windowClass: 'addModal'
                    templateUrl: "templates/#{namespace.replace /\.+/g, "/"}/form.operatorprofile.tpl.html"
                    resolve:
                        entity: ->
                            return new APIService.getOperator(item)
                        userRolesList:->
                            return []# APIService.getRolesList()
                        isNew: ->
                            console.log item? true || false
                            if item?
                                return false
                            else
                                return true

                    controller: [
                        "$scope"
                        "$modalInstance"
                        "entity"
                        "userRolesList"
                        "isNew"
                        "NotificationService"
                        ($scope, $modalInstance, entity,userRolesList,isNew,NotificationService)->
                            $scope.isNew = isNew
                            $scope.isBusy = false

                            console.log 'entity',isNew,entity
                            $scope.userRolesList = userRolesList

                            if isNew
                                $scope.currEntity = null
                                $scope.editEntity = entity
                            else
                                $scope.currEntity = _.clone entity
                                $scope.editEntity = entity
                                $scope.editEntity.canEdit = true
                            ###* set new password for user ###
                            $scope.onSetNewPassword = (params=null)->
                                $scope.isBusy = true
                                delDlg = DialogService.confirm "Set new password","Are you sure you want to generate new password for <strong>#{$scope.currEntity.userName}</strong>?"
                                delDlg.result.then(
                                    (result)->
                                        console.log params
                                        $scope.editEntity.$updatePassword().then(
                                            (result)->
                                                $scope.isBusy = false
                                                NotificationService.success 'Success', "A new password is generated and sent by email <strong>#{result.userName}</strong>"
                                            (error)->
                                                if  error.data?.message? and error.status != 500
                                                    NotificationService.error 'Error', error.data.message
                                                $scope.isBusy = false
                                        )
                                    (error)->
                                        $scope.isBusy = false
                                )

                            ###* on save in server-side ###
                            $scope.onSave = ->
                                $scope.isBusy = true
                                if isNew
                                    $scope.editEntity.$save().then(
                                        (result)->
                                            console.log result
                                            $scope.isBusy = false
                                            $scope.tableParams.reload()
                                            $modalInstance.close(entity)
                                        (error)->
                                            $scope.isBusy = false
                                    )
                                else
                                    console.log '====',$scope.editEntity
                                    $scope.editEntity.$update().then(
                                        (result)->
                                            $scope.isBusy = false
                                            console.log result
                                            $modalInstance.close(entity)
                                        (error)->

                                            $scope.isBusy = false
                                    )
                                #$scope.tableData.push($scope.newItem)
                                #$scope.tableParams.reload()
                                #$modalInstance.close(entity)
                                #else
                                #    TasksDataService.notifyService.info 'Duplicate', "Attribute #{$scope.newItem.attributeName} already exist"
                            $scope.onCancel = ->
                                $modalInstance.dismiss('cancel')

                    ]
                    scope: $scope
                ).result.then(
                    (result)->
                        console.log result ,'=?=',item
                        if item?
                            _.extend item , result
                    (result)->
                        console.log result

                )
    ]