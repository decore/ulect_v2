###
###
require.ensure ['./../main'],(r)->

#ngModule = require './../routes'
    #    ngModule.run [ ->
    #        alert 'run'
    #    ]
module.exports = {
    init: ->
        alert ''
}