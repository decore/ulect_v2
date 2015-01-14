###*
* PagesController
* @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
module.exports = {
    ## home page
    index: (req,res)->
        res.view 'pages/home',
            user: req.user
            ng_spa_name: 'debug'
    ## SPI
    spi: (req,res)->
        res.view 'pages/home',
            user: req.user
            ng_spa_name: 'debug'
    auth: (req,res)->
        res.view 'pages/auth',
            user: req.user
            layout:'layouts/layout_login'
            ng_spa_name: 'debug'
    ## operator chat room
    chatroom: (req,res)->
            ##TODO: use real information about user
            return res.view
                user: req.user 
                ng_spa_name: 'chatroom'

    management: (req,res)->
        res.view 'pages/home',
            user: req.user
            ng_spa_name: 'management'

}
