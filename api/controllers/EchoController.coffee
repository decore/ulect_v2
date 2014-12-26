###*
* Echo Controller
* @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
format = require("string-template")
module.exports = {
    index: (req,res)->
        message = format  "{DEMO}", DEMO: "Demo name"+"Demo "
        return res.json {msg:message}

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
    key: (req, res)->

        res.json key:cryptoService.genAPIkey(req.param('id'))
    ##Buy number for client
    buy: (req,res)->
        phoneNumberForBuy = '+15005550006'
        User.findOne().exec(
            ()->

        )
        User.findOne().then(
            (client)->
                profile = Profile.findOne(owner:client.id).then(
                    (_profile)->
                        return _profile
                )
                return [user,profile]
        ).spread(
            (_user,_profile)->

                options_buy = {
                      friendlyName: _profile.companyname
                      phoneNumber: phoneNumberForBuy
                }

                TwilioService.buyNumber(options_buy,(err,number)->
                    if err
                        res.status err.status
                        res.json err
                    else
                        if number?.sid?
                            options_transfer = {
                                newAccountSid: 'AC220dd9ec0df20b77d7cdd306ee34f43a'
                                phoneSid: number.sid
                                friendlyName: _profile.companyname #"Client Company name"
                            }
                            TwilioService.transferPhoneNumber(options_transfer, (err,info)->
                                if err
                                    res.status 400
                                    res.json err
                                else
                                    res.json info
                            )
                        else
                            res.status 400
                            res.json msg:"Phone Number not exists"
                )
        ).fail(
            (err)->
                res.status 400
                res.json msg:"User not found",err:err
        )

}