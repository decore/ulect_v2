###
Namespace module
###
define ['cs!./../namespace'], (parent_namespace)->
    _default_namespace = 'settings' #NOTE: default namespace is name folder
    return parent_namespace + '.' + _default_namespace