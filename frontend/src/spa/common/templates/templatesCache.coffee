###
Cache content of template(s) with current name space
###
define [
    'cs!./../module'
    'text!./home.tpl.html'
    'text!./auth/login.tpl.html'
    'text!./auth/register.tpl.html'
    'text!./auth/activate.tpl.html'
    'text!./password/index.tpl.html'
    'text!./password/reset.tpl.html'
    'text!./password/verification.tpl.html'
], (module
    tplIndex
    tplLogin
    tplRegister
    tplActivate
    tplPasswordIndex
    tplPasswordReset
    tplPasswordVerification
)->
    console.log "templates/#{module.name.replace /\.+/g, "/"}/index.tpl.html"
    module.run ['$templateCache', ($templateCache)->
        $templateCache.put "templates/#{module.name.replace /\.+/g, "/"}/home.tpl.html", tplIndex

        $templateCache.put "templates/#{module.name.replace /\.+/g, "/"}/auth/login.tpl.html", tplLogin
        $templateCache.put "templates/#{module.name.replace /\.+/g, "/"}/auth/register.tpl.html", tplRegister
        $templateCache.put "templates/#{module.name.replace /\.+/g, "/"}/auth/activate.tpl.html", tplActivate


        $templateCache.put "templates/#{module.name.replace /\.+/g, "/"}/password/index.tpl.html", tplPasswordIndex
        $templateCache.put "templates/#{module.name.replace /\.+/g, "/"}/password/reset.tpl.html", tplPasswordReset
        $templateCache.put "templates/#{module.name.replace /\.+/g, "/"}/password/verification.tpl.html", tplPasswordVerification

    ]