define [
    'cs!./module'
    'cs!./templates/templatesCache'
],(module)->
     
    module.run [ ->
        console.log "init #{module['name']}"
    ]
    return module