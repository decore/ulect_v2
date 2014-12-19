define ['cs!./namespace', 'cs!./module', 'cs!./config'], (namespace,module)->
    module.run [ ->
        console.log "init #{module['name']}"
    ]
    return module#namespace