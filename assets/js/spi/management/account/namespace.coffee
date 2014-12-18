###
Namespace module
###
define ['cs!./../namespace'], (parent_namespace)->
    _default_namespace = 'account' #NOTE: default namespace is name folder
    return parent_namespace + '.' + _default_namespace