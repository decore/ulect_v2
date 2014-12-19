###
Cache content of template(s) with current name space
###
define [
    'cs!./../module'
    'tpl!./index.tpl.html'
    'tpl!./form.entity.tpl.html'
], (module
    tplIndex
    tplForm
)->
    console.log "templates/#{module.name.replace /\.+/g, "/"}/index.tpl.html"
    module.run ['$templateCache', ($templateCache)->
        $templateCache.put "templates/#{module.name.replace /\.+/g, "/"}/index.tpl.html", tplIndex(namespace:module.name.replace /\.+/g, "_")

        $templateCache.put "templates/#{module.name.replace /\.+/g, "/"}/form.entity.tpl.html", tplForm(namespace:module.name.replace /\.+/g, "_")
        ## aliases template
        $templateCache.put "templates/#{module.name.replace /\.+/g, "/"}/form.create.tpl.html", tplForm(namespace:module.name.replace /\.+/g, "_")
        $templateCache.put "templates/#{module.name.replace /\.+/g, "/"}/form.edit.tpl.html", tplForm(namespace:module.name.replace /\.+/g, "_")


    ]