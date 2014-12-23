###
Cache content of template(s) with current name space
###
define [
    'cs!./../module'
    'text!./home.tpl.html'
    'text!./auth/login.tpl.html'
    'text!./auth/register.tpl.html'
    'text!./auth/activate.tpl.html'
], (module
    tplIndex
    tplLogin
    tplRegister
    tplActivate
)->
    console.log "templates/#{module.name.replace /\.+/g, "/"}/index.tpl.html"
    module.run ['$templateCache', ($templateCache)->
        $templateCache.put "templates/#{module.name.replace /\.+/g, "/"}/home.tpl.html", tplIndex

        $templateCache.put "templates/#{module.name.replace /\.+/g, "/"}/auth/login.tpl.html", tplLogin
        $templateCache.put "templates/#{module.name.replace /\.+/g, "/"}/auth/register.tpl.html", tplRegister
        $templateCache.put "templates/#{module.name.replace /\.+/g, "/"}/auth/activate.tpl.html", tplActivate
    ]