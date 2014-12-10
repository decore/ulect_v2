define ['cs!./../namespaces'],(namespaces)->
    ClassController = ($scope,EntityFactory,SocketEntityFactory, DialogService)->


        SocketEntityFactory.load()
        EntityFactory.getRefEntity_N1().$promise.then(
            (data)->
               $scope.fastanswersList = data
        )
        $scope.entitiesList= SocketEntityFactory.data
        $scope.tableParams = EntityFactory.tableParams
        $scope.currentChatRoom = []
        ###* confirm delete (used service) ###
        $scope.onDeleteUser = (item)->
            delDlg = DialogService.deleteDialog "Confirm delete","Вы действительно желаете удалить запись?"
            delDlg.result.then(
                ##confirn delete entity
                (res)->
                    $scope.isBusy = true
                    item.$delete().then(
                        (result)->
                            $scope.isBusy = false
                            $scope.tableParams.reload()
                            #$modalInstance.close(null)
                        (error)->
                            $scope.isBusy = false
                    )
            )
        $scope.onShowHistory = $scope.onCreateEntity = (_id=null)->
            DialogService.create("templates/#{namespaces.module.name.replace /\.+/g, "/"}/form.entity.tpl.html","Edit_#{namespaces.module.name.replace /\.+/g, "_"}_Controller", id:_id).result.then(
                (data)->
                    $scope.tableParams.reload()
                    console.log 'data',data
                (err)->
                    console.log 'eer',err
            )
        ## on Set Current Client Room is active
        $scope.onSetCurrentChatRoom = (item)->
            if $scope.currentChatRoom?.$isNewMsg?
                $scope.currentChatRoom.$isNewMsg = false
            $scope.currentChatRoom = item
            return
        $scope.sortCreatedAt = (msg)->
            console.log msg
            date = new Date(msg.createdAt)
            return date;
        $scope.onSendMessage = (_event,roomId,message)->
            console.log roomId,message
            SocketEntityFactory.sendData(roomId,message).then(
                (data)->
                    console.log 'is ok send '
                    $scope.messagesForUser = ''
            )
            return

    return ['$scope',"#{namespaces.name}EntityFactory","#{namespaces.name}SocketEntityFactoryClass", 'DialogService',ClassController]