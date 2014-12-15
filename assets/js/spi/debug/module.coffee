###
module and class dependecies
###
_dependencies = [
    'angular'
    'cs!./namespaces'
    ]
###

###
define _dependencies ,(
    angular
    namespaces
)->

    module =  angular.module namespaces.module.name,[]

    return module