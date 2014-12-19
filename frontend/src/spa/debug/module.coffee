###
module and class dependecies
###

###

###
define ['angular', 'cs!./namespaces'] ,(
    angular
    namespaces
)->

    module =  angular.module namespaces.module.name,[]

    return module