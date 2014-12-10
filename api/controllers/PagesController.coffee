###*
* PagesController
* @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
module.exports = {
    index: (req,res)->
        res.view 'pages/home',
            user: req.user
            ng_spa_name: 'debug'
    chatroom: (req,res)->
            res.view
                user: {username: "Demo User"}
                ng_spa_name: 'chatroom'
}