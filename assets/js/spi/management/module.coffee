###
@exports "management"
###
define ['angular'
        'cs!./namespace'
        'cs!./operators/index'
        'ng-table'
], (
    angular
    namespace
    operatorsModule

)->
    console.log 'Module "management"', namespace,operatorsModule
    return angular.module namespace, [
        operatorsModule
        'ngResource'
        'ngTable'
    ]