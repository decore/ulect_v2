define ['sails.io'],->
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
        _handlers.messaged = (msg)->
            switch msg.data.verb
                when "new:messages"
                    console.log msg.data.data,
                    _room = _.findByValues(_dataList, "id", [msg.data.data.chatroom])[0];
                    console.log 'find ',  _.find _dataList, chatroom:msg.data.data.chatroom
                    if _.isObject msg.data.data.owner
                        msg.data.data.owner = msg.data.data.owner.id
                    #_dataList.push(msg.data.data)
                    console.log "I GET ",_room
                    _.merge _room, $isNewMsg:true
                    console.log
                    _room.msgs.push msg.data.data

        console.warn 'start .subscribe user'
        #        $sailsSocket.subscribe 'messages',(msg)->
        #            console.log 'is get socket msgs on subscribe',msg
        #            return

        $sailsSocket.subscribe 'chatrooms',(msg)->
            console.log 'is get socket msgs',msg
            _handlers[msg.verb](msg)
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
        #_loadMessages()
        _sendMessage = (dialogId,msg)->
            return $http.post(Entity_API_Url,{ dialog:dialogId, body:msg}).then(
                (data)->
                    console.log 'data send ok', data
                (reason)->
                    console.log 'data send error', reason
            )

            #            return $sailsSocket.post(Entity_API_Url+'/'+roomId+'/message',msg).then( (res)->
            #                _dataList.push(res.data);
            #                return res.data;
            #            )

        return {
            data: _dataList
            #load: _loadMessages
            sendData: _sendMessage
        }
    return ['$sailsSocket','$http',SocketEntityFactoryClass]