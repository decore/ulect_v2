###
@exports "management"
###
define ['angular'
        'cs!./namespace'
        'cs!./operators/index'
        'cs!./account/index'
        'ng-table'
], (
    angular
    namespace
    operatorsModule
    accountModule
)->
    console.log 'Module "management"', namespace,operatorsModule
    return angular.module namespace, [
        operatorsModule
        accountModule
        'ngResource'
        'ngTable'
    ]