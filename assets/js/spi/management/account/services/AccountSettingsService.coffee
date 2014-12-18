###* AccountSettingsService ###
define ['cs!./../module'],(module)->
    module.factory 'AccountSettingsService',[
        '$q'
        '$resource'
        '$http'
        'baseUrl'
        ($q,$resource,$http,baseUrl)->
            _resource = $resource baseUrl+'/accountsettings/:id/:action',
                {"id":"@id"}
                    get:
                        method: "GET"
                    save:
                        method: "POST"
                    query:
                        method: "GET"
                        isArray: true
                        headers:
                            'X-Prism-Total-Items-Count': 'true'
                    update:
                        method: 'PUT' 

                    delete:
                        method: 'DELETE',
                        headers:
                            'Content-Type': 'application/json'


            return  {
                query: _resource.query
                getOperator: (params=null)->
                    user = new _resource(params)
                    user.$get() if !!params
                    return user
                #getTimeZonesList: $resource(baseUrl+'/timezones').query
                getRolesList: -> []#$resource(baseUrl+'/users/roles').query

            }

    ]