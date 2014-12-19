###
Namespace module
###
define ['cs!./../namespace'], (parent_namespace)->
    _default_namespace = 'operators' #NOTE: default namespace is name folder
    return parent_namespace + '.' + _default_namespace