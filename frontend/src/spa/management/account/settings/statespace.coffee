###
Statespace
###
define ['cs!./../statespace'], (parent_statespace)->
    _default_statespace_name = 'settings' ##default statespace name
    return {
        name: "#{parent_statespace.name}.#{_default_statespace_name}"
        url: "/#{_default_statespace_name}"
        pageTitle: "Account Settings"
    }