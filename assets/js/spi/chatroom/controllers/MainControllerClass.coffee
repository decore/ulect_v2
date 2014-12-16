define ['cs!./../namespaces'],(namespaces)->
    ClassController = ($scope,EntityFactory,SocketEntityFactory, DialogService,$http,$sailsSocket,CurrentUser)->
        currentUser =  CurrentUser.user
        ##
        $sailsSocket.subscribe 'messages',(msg)->
            console.log '  get on controller AC220dd9ec0df20b77d7cdd306ee34f43a',msg
            if msg.verb == "create"
                (_.find($scope.conversationList, id: msg.data.dialog)).msgs.push msg.data
            else
                console.log 'TODO: update status of messages'
            return
        ## Conversation
        $sailsSocket.subscribe 'conversations',(msg)->
            console.log 'conversations ',msg
            switch msg.verb
                when "create"
                    console.log 'event create conversations ',msg
                    msg.data.msgs = []
                    $scope.conversationList.push msg.data #if $scope.currentChatMessages?
                when "update"
                    console.log 'event update conversations ',msg
                    _.extend _.find($scope.conversationList, id: msg.data.id), msg.data
            return

        ## Operators
        $sailsSocket.subscribe 'operator',(msg)->
            switch msg.verb
                when "create"
                    console.log 'event create operator ',msg
                    $scope.operatorsList.push msg.data
                when "update"
                    console.log 'event update operator ',msg
                    _.extend _.find($scope.operatorsList, id: msg.data.id) ,  msg.data
            return


        $scope.conversationList = []
        $scope.operatorsList = []
        $http.get('/api/v1/user').success(
            (data)->
                $scope.operatorsList = data
        )

        $http.get('/api/v1/conversations').success(
            (data)->
                $scope.conversationList = data
        )
        #SocketEntityFactory.load()
        #        EntityFactory.query().$promise.then(
        #            (data)->
        #                $scope.fastanswersList = data
        #        )
        #        EntityFactory.getRefEntity_N1().$promise.then(
        #            (data)->
        #               $scope.fastanswersList = data
        #        )
        $scope.entitiesList= SocketEntityFactory.data
        $scope.tableParams = EntityFactory.tableParams
        $scope.currentChatRoom = null
        $scope.currentChatMessages = null
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
        ## on Set Current dialog
        $scope.onSetCurrentChatRoom = (item)->
            if $scope.currentChatRoom?.$isNewMsg?
                $scope.currentChatRoom.$isNewMsg = false

            $scope.currentChatRoom = item
            $scope.currentChatMessages = item.msgs
            return

        ## Send message
        $scope.onSendMessage = (_event,dailogId,message)->
            console.log 'onSendMessage ',dailogId,message
            $scope.isLocked = true
            SocketEntityFactory.sendData(dailogId,message).then(
                (data)->
                    console.log 'is ok send '
                    $scope.messagesForUser = ''
                    $scope.isLocked = false
                (err)->
                    $scope.isLocked = false
            )
            return

        ## on Start dialog between Operator and Client
        $scope.onStartDialog  = (_event,dailogId,message)->
            console.log 'onStartDialog',dailogId
            if $scope.currentChatRoom?
                ##TODO: make request like RESTfull
                $http.post("/api/v1/conversations/#{dailogId}/operator",{id:dailogId, isactive: true , operator: currentUser().id}).then(
                    (data)->
                        console.log  data
                        $scope.currentChatRoom.operator =  data.data.operator
                )
            return
        ## on Terminate dialog
        $scope.onTerminateDialog  = (_event,dailogId,message)->
            console.log 'onStartDialog',dailogId
            if $scope.currentChatRoom?
                ##TODO: make request like RESTfull
                $http.put("/api/v1/conversations/#{dailogId}",{isactive:false}).then(
                    (data)->
                        $scope.currentChatRoom.isactive = false
                        $scope.currentChatRoom = null
                        $scope.currentChatMessages = null
                    (msg)->
                        alert 'Error'
                        console.log msg
                )
                #                   SocketEntityFactory.sendData(roomId,message).then(
                #                       (data)->
                #                           console.log 'is ok send '
                #                           $scope.messagesForUser = ''
                #
                #                   )
            return

    return ['$scope',"#{namespaces.name}EntityFactory","#{namespaces.name}SocketEntityFactoryClass", 'DialogService','$http','$sailsSocket','CurrentUserService',ClassController]