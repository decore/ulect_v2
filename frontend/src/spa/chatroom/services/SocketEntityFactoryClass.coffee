define [],->
    "use strict"
    _.mixin(#http://stackoverflow.com/questions/17251764/lodash-filter-collection-using-array-of-values
        'findByValues': (collection, property, values)->
            return _.filter collection, (item)->
                return _.contains(values, item[property])
    )

    Entity_API_Url = "/api/v1/messages"

    SocketEntityFactoryClass = ($sailsSocket,$http)->
        _dataList = []
        _handlers = {}
        #        _handlers.created = (msg)->
        #            _dataList.push(msg.data)
        #
        #        _handlers.updated = (msg)->
        #            _dataList.push(msg.data)
        #        _handlers.messaged = (msg)->
        #            switch msg.data.verb
        #                when "new:messages"
        #                    console.log msg.data.data,
        #                    _room = _.findByValues(_dataList, "id", [msg.data.data.chatroom])[0];
        #                    console.log 'find ',  _.find _dataList, chatroom:msg.data.data.chatroom
        #                    if _.isObject msg.data.data.owner
        #                        msg.data.data.owner = msg.data.data.owner.id
        #                    #_dataList.push(msg.data.data)
        #                    console.log "I GET ",_room
        #                    _.merge _room, $isNewMsg:true
        #                    console.log
        #                    _room.msgs.push msg.data.data
        #        $sailsSocket.subscribe 'messages',(msg)->
        #            console.log 'is get socket msgs on subscribe',msg
        #            return

        #        $sailsSocket.subscribe 'chatrooms',(msg)->
        #            console.log 'is get socket msgs',msg
        #            _handlers[msg.verb](msg)
        #            return
        _conversationList = []
        _operatorsList = []
        $http.get('/api/v1/operators').success(
            (data)->
                _.forEach data, (item)->
                    _operatorsList.push item# = data
        )

        $http.get('/api/v1/conversations').success(
            (data)->
                _.forEach data, (item)->
                    _conversationList.push item # data
        )
        ##
        $sailsSocket.subscribe 'messages',(msg)->
            console.log 'get on controller', msg
            if msg.verb == "create"
                console.log '-=-',_conversationList
                (_.find(_conversationList, id: msg.data.dialog)).msgs.push msg.data
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
                    _conversationList.push msg.data #if $scope.currentChatMessages?
                when "update"
                    console.log 'event update conversations ',msg
                    _.extend _.find(_conversationList, id: msg.data.id), msg.data
            return

        ## Operators
        $sailsSocket.subscribe 'operator',(msg)->
            switch msg.verb
                when "create"
                    console.log 'event create operator ',msg
                    _operatorsList.push msg.data
                when "update"
                    console.log 'event update operator ',msg
                    _.extend _.find(_operatorsList, id: msg.data.id) ,  msg.data
            return

        _loadMessages = ()->
            return $sailsSocket.get(Entity_API_Url).then( (res)->
                _dataList.length = 0

                angular.forEach(res.data.chatrooms,(item)->
                    item.msgs = _.sortBy item.msgs, 'createdAt'
                    _dataList.push(item)
                )
                return _dataList;
            )
        _sendMessage = (dialogId,msg)->
            return $http.post(Entity_API_Url,{ dialog:dialogId, body:msg})
        return {
            data: _dataList
            conversationList: _conversationList
            operatorsList: _operatorsList
            sendData: _sendMessage
        }
    return ['$sailsSocket','$http',SocketEntityFactoryClass]