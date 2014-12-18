###
Entry point in module
###
define [
    'cs!./namespace'
    'cs!./module'
    'cs!./config'
    'cs!./templates/templatesCache'
    #'cs!./tests/backendFakeData' ##NOTE: used for develop UI without server-side ##TODO: delete on production
], (namespace)->
    return namespace