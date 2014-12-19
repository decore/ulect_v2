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
        console.log sails.config.twilio
        ##TODO: use real information about user
        Users.findOne(id:1).exec(
          (err, user )->
            if err
                user={}
            return res.view
                user: user
                ng_spa_name: 'chatroom'
        )
    management: (req,res)->
        res.view 'pages/home',
            user: req.user
            ng_spa_name: 'management'

}
