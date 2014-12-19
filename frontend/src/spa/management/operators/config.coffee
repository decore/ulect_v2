###
Module configuration
###
define [
    'cs!./namespace'
    'cs!./module'
    'cs!./statespace' ## Configuration for ui-route state
    'cs!./services/ManageOperatorsService'
    'cs!./controllers/ManageOperatorsController'
], (namespace, module, statespace)->
    module.config ['$stateProvider', ($stateProvider)->
        ###
        Main configuration $stateProvider
        ###
        console.log  statespace.url,statespace.name
        $stateProvider.state statespace.name,
            url: statespace.url
            #views:
            #    "main@": ##TODO: do control name ui-view for display template content
            templateUrl: "templates/#{namespace.replace /\.+/g, "/"}/operators.tpl.html"
            controller: 'ManageOperatorsController'
            resolve:
                APIService: ['ManageOperatorsService' , (_APIService)->
                    return _APIService

                ]
            data:
                pageTitle: statespace.pageTitle  
    ]
