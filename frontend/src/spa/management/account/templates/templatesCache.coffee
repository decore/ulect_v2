###
Cache content of template(s) with current name space
###
define [
    'cs!./../module'
    'cs!./../namespace'
    'text!./profile.tpl.html'
    'text!./settings.tpl.html'
], (module
    namespace
    tplIndex
    tplSettings
)->
    module.run ['$templateCache', ($templateCache)->
        $templateCache.put "templates/#{namespace.replace /\.+/g, "/"}/profile.tpl.html", tplIndex
        $templateCache.put "templates/#{namespace.replace /\.+/g, "/"}/settings.tpl.html", tplSettings

    ]