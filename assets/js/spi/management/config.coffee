define [
    'cs!./namespace'
    'cs!./module'
    'cs!./statespace'
    'text!./management.tpl.html'
], (namespace, module, statespace, tplIndex)->

    module.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider)->
        console.log statespace.url,  statespace.name.split('.')
        $stateProvider.state statespace.name.split('.')[0],
            abstract: true
            template: "<div ui-view>"

        $stateProvider.state statespace.name,
            url: statespace.url
            #views:
            #    "main@":
            templateUrl: 'templates/administration/management/management.tpl.html'
                    #controller: 'ManagementController'
            data:
                pageTitle: statespace.pageTitle
    ]

    module.run ['$templateCache',  ($templateCache)->
        $templateCache.put('templates/administration/management/management.tpl.html', tplIndex)
    ]
