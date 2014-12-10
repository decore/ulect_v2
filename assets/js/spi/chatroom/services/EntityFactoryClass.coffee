###
Main Entety for work
###
define [],->
    Entity_API_Url = "/api/v1/operator/chatroom"
    RefEntity_N1_API_Url = "/api/v1/fastanswers" ##TODO: change
    EntityClass = ($resource,$http, ngTableParams)->
        APIService = new $resource "#{Entity_API_Url}/:chatroom/:action/:id", id:"@id",
            'query':
                method:'GET'
                isArray:true
            'update':
                method: 'PUT'
            'delete':
                method: 'DELETE'
                params:
                    action: "message"
                    chatroom: "@chatroom"

        ## Table Params
        _tableParams  = new ngTableParams
            page: 1
            count: 50
            sorting:
                id: 'asc'  # special settings for this table
            ,
                total: 0, # length of data
                counts:[10,50,100],
                getData: ($defer, params)->
                    #console.log params.orderBy()
                    paramSend =
                        sort: params.sorting()#orderBy()#.join()
                        limit: params.count()
                        page: params.page()

                    _.extend paramSend , angular.copy params.filter()
                    APIService.query( paramSend,
                        (result,p)->
                            params.total(p()['x-prism-total-items-count'])# update table params
                            $defer.resolve result#[0].chatrooms# set new data
                        (result)->
                            $defer.resolve()# resolve

                    )
                #$scope: $scope.$new()

        _resource = new $resource "#{RefEntity_N1_API_Url}/:id", id:"@id",
            'query':
                method:'GET'
                isArray:true

        _refEntity_N1 = _resource.query(
            (data)->
                _refEntity_N1.length = 0
                _refEntity_N1 = data
                console.log _refEntity_N1
                return
        )
        return {
            getRefEntity_N1: ->
                return _resource.query()
            tableParams: _tableParams
            getEntity: (_id)->
                return APIService.get(id:_id)
            saveEntity: (data  = null)->
                console.log data
                if data.id
                    _action = 'update'
                else
                    _action = 'save'
                return  APIService[_action] data
                #else
                #    return  APIService.save data
            #            saveEntity: (data  = null)->
            #                console.log data
            #                return  APIService.save data
        }
    return ['$resource','$http','ngTableParams',EntityClass]