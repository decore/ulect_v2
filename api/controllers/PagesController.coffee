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
                user:
                    username: "Demo User"
                    role: {id:2,name:'operator'}
                    sid: "AC220dd9ec0df20b77d7cdd306ee34f43a"
                ng_spa_name: 'chatroom'
}