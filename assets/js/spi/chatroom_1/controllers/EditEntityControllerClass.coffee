###
Controller EditType Class
###
define ['cs!./../namespaces'],(namespaces)->
    ClassEditController = ($scope,$modalInstance,EntityFactory,SocketEntityFactory,data)->
        ##console.log data, EntityFactory.saveEntity
        $scope.editEntity = {}#EntityFactory.getEntity(data.id) if data.id
        $scope.tableParams = EntityFactory.tableParams

        $scope.currEntity = data

        #        $scope.onSave = (data=null)->
        #            console.log @editEntity
        #            EntityFactory.saveEntity(@editEntity).$promise.then(
        #                (data)->
        #                    $modalInstance.close()
        #                (err)->
        #                    return
        #            )
        $scope.onCancel  = ->
            $modalInstance.dismiss()
        $scope.onDeleteEntity = (item)->
            if confirm "Удалить сообщение?"
                console.log item

                item.$delete(chatroom:item.chatroom).then(
                    (data)->
                        $scope.tableParams.reload()
                    (err)->
                        return
                )
        ###* confirm delete (used service) ###
        $scope.tableParams.filter()["id"]= data.id
        #        EntityFactory.getRefEntity_N1().$promise.then(
        #            (data)->
        #               $scope.operatorsList = data
        #        )
        #            [
        #            id:1
        #            username: "TEst"
        #        ]
        #console.debug EntityFactory.refEntity_N1
    return ['$scope','$modalInstance',"#{namespaces.name}EntityFactory","#{namespaces.name}SocketEntityFactoryClass",'data',ClassEditController]