 # APIcallController
    #
    # @description :: Server-side logic for managing Apicontrollers
    # @help        :: See http://links.sailsjs.org/docs/controllers
request = require('request');
module.exports = {
    ## List operators for user subAccount
    getOperators: (req,res)->
        key = req.param("key");
        # find user
        User.findOne().where(APIkey:key).exec(
            (err,user)->
                if err
                    return res.json err
                if  !user
                    res.status 403
                    return res.json message:"API key not found"
                ##TODO: pesmission test
                #                if  user.active != true
                #                    res.status 403
                #                    return res.json
                ##NOTE: get operators list
                User.find(AccountSid: user.AccountSid).exec(
                    (err,operators)->
                        if err
                            res.status 500
                            return res.json message:"Server error"
                        return res.json key: key, user:user,operators:operators
                )
        )
    ## send message user
    sendMessage:(req,res)->
        _key = req.param("key");
        _sendTo = req.param("phonenumber");
        _sendBody = req.param("body");
        console.log req.params.all();
        User.findOne().where(APIkey:_key).exec(
            (err,user)->
                if err
                    res.staus 500
                    res.json message:"Server error"
                else
                    if !user
                        res.status 403
                        return res.json message:"API key not found"
                    ##TODO: check user permissin
                    ##NOTE: send message and make callback
                    ##NOTE: send
                    Conversations.findOne(client:_sendTo, isactive:true ).exec(
                        (err,dialog)->

                            if err
                                return res.json err
                            if !dialog
                                res.status 500
                                return res.json err:msg:"Dialog not found or not active"
                            _params =
                                to : dialog.client
                                body: _sendBody
                            #console.log "TO SEND params ",_params
                            TwilioService.sendSMS( _params, (err,message)->
                                console.log 'is send message', message
                                ##TODO: replace demo operator
                                _.extend message , { dialog : dialog.id, operator: user.id }
                                console.log 'is extend message===', message
                                if err
                                    res.status 500
                                    return res.json err
                                dialog.isWaitAnswer = false
                                Messages.create(message).exec(
                                    (err,entity)->
                                        if err
                                            res.status 500
                                            return res.json err
                                        if !entity
                                            res.status 418
                                            return res.json err
                                        dialog.save(
                                            (err)->
                                                #delete entity.operator
                                                _params.id = entity.id
                                                return res.json result:"Send Ok", message: _params
                                        )

                                )
                            )
                    )
        )

}
