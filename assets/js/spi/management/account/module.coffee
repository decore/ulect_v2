###
 Template faile Mdule dependencies
 @exports "_module"
 @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
define ['angular'
        'cs!./namespace'
        #'cs!common/index' ## Use common module
], (
    angular
    namespace
    #commonModule
    )->
    ## create instance angularjs module
    return angular.module namespace, [
        #commonModule
    ]