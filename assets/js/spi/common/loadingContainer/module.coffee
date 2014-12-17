###
Module "loading-container"
###
define [
    'angular'
    'cs!./namespace'
], (angular
    namespace)->
    return angular.module namespace, []