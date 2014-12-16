###
Cache content of template(s) with current name space
###
define [
    'cs!./../module'
    'cs!./../namespace'
    'text!./instructionDialogTemplate.tpl.html'
    'text!./deleteDialogTemplate.tpl.html'
], (module
    namespace
    instructionDialogTemplate
    deleteDialogTemplate)->
    module.run ['$templateCache', ($templateCache)->
        $templateCache.put "templates/#{namespace.replace /\.+/g, "/"}/instructionDialogTemplate.tpl.html", instructionDialogTemplate
        $templateCache.put "templates/#{namespace.replace /\.+/g, "/"}/deleteDialogTemplate.tpl.html", deleteDialogTemplate
    ]