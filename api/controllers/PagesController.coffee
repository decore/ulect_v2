###*
* PagesController
* @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
module.exports = {
    index: (req,res)->
        res.view 'pages/home',
            user: req.user
    auth: (req,res)->
        res.view 'pages/auth',
            user: req.user
            layout:'layouts/layout_login'
}