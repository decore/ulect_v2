###
Namespace module
###
define ['cs!./../namespaces'], (parent_namespace)->
    _default_namespace = 'loadingContainerDirective'
    return parent_namespace.module.name + '.' + _default_namespace