###
Statespace
###
define ['cs!./../statespace'], (parent_statespace)->
    _default_statespace_name = 'operators' ##default statespace name
    return {
        name: "#{parent_statespace.name}.#{_default_statespace_name}"
        url: "/#{_default_statespace_name}"
        pageTitle: "Operator Management"
    }