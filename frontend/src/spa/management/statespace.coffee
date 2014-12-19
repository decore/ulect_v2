define ['cs!./../statespace'], (statespace)->
    _default_statespace_name = 'management'
    return {
        name: statespace.name + '.' + _default_statespace_name
        url: '/' + _default_statespace_name
        pageTitle: 'Management'
    }