###
Cache content of template(s) with current name space
###
define [
    'cs!./../module'
    'cs!./../namespace'
    'text!./accountsettings.tpl.html'
    'text!./form.operatorprofile.tpl.html'
], (module
    namespace
    tplIndex
    tplUserForm
)->
    module.run ['$templateCache', ($templateCache)->
        $templateCache.put "templates/#{namespace.replace /\.+/g, "/"}/accountsettings.tpl.html", tplIndex
        $templateCache.put "templates/#{namespace.replace /\.+/g, "/"}/form.operatorprofile.tpl.html", tplUserForm
    ]