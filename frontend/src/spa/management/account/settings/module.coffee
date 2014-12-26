###
 Template faile Mdule dependencies
 @exports "_module"
 @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
define ['angular'
        'cs!./namespace'
], (
    angular
    namespace
    )->
    ## create instance angularjs module
    return angular.module namespace, [
    ]