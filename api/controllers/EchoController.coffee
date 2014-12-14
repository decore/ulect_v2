###*
* Echo Controller
* @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
module.exports = {
    index: (req,res)->
       return res.json {}

    rooms: (req, res)->
        roomNamesAll = JSON.stringify(sails.sockets.rooms());
        roomNames = JSON.stringify(sails.sockets.socketRooms(req.socket));
        return res.json
            roomNamesAll: 'All subscribes: '+roomNamesAll
            roomNames: 'I am subscribed to: '+roomNames
    inform: (req, res)->
        _params = req.params.all()
        sails.sockets.broadcast('AC220dd9ec0df20b77d7cdd306ee34f43a','message', { params: _params});
        return res.json msg:"was send data ", data: _params
}