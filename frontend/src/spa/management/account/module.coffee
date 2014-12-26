###
  @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
define ['angular'
        'cs!./namespace'
        # 'cs!./settings/index'
], (
    angular
    namespace
    #settingsModule
    )->
    ## create instance angularjs module
    return angular.module namespace,[]# [settingsModule]