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
    auth: (req,res)->
        res.view 'pages/auth',
            user: req.user
            layout:'layouts/layout_login'
            ng_spa_name: 'debug'
    ## operator chat room
    chatroom: (req,res)->
        ##TODO: use real information about user
        Users.findOne(id:1).exec(
          (err, user )->
            if err
                user=
                    id: 1
                    username: "Demo User ID1"
                    role: {id:2,name:'operator'}
                    sid: "AC220dd9ec0df20b77d7cdd306ee34f43a"

            return res.view
                user: user
                ng_spa_name: 'chatroom'
        )
}
