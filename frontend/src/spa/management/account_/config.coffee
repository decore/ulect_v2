###
Module configuration
###
define [
    'cs!./namespace'
    'cs!./module'
    'cs!./statespace' ## Configuration for ui-route state
    'cs!./services/AccountSettingsService'
    'cs!./controllers/AccountSettingsController'
], (namespace, module, statespace)->
    module.config ['$stateProvider', ($stateProvider)->
        ###
        Main configuration $stateProvider
        ###
        $stateProvider.state statespace.name,
            url: statespace.url
            #views:
            #    "main@": ##TODO: do control name ui-view for display template content
            templateUrl: "templates/#{namespace.replace /\.+/g, "/"}/accountsettings.tpl.html"
            controller: 'AccountSettingsController'
            resolve:
                APIService: ['AccountSettingsService' , (_APIService)->
                    return _APIService
                ]
            data:
                pageTitle: statespace.pageTitle
    ]
