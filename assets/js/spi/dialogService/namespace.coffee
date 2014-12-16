###
Namespace module
###
#define ['cs!./../namespace'], (parent_namespace)->
#    _default_namespace = 'dialogService'
#    return parent_namespace + '.' + _default_namespace

define [], (parent_namespace)->
    _default_namespace = 'dialogService'
    return _default_namespace