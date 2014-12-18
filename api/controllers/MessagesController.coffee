###*
* MessagesController
* @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
module.exports = {
    ## migrate data from twilio
    migrate: (req,res)->
        TwilioService.messagesList({PageSize:350},(err,data)->
            console.log  err,data.messages
            _.forEach data.messages, (message)->
                Messages.create(message).exec(
                    (err,data)->
                        return res.json data
                )
        )
    ## socket suscribe

    ## method add(send) new message (POST request)
    newMessage: (req,res)->
        _params = req.params.all()
        ##TODO: API key controll
        ##TODO: API SID controll
        console.log '===> newMessages',_params
        if !_params.dialog?
            res.status 500
            return res.json err:msg:"dialog id must be send"
        Conversations.findOne(id:_params.dialog, isactive:true ).exec(
            (err,dialog)->

                if err
                    return res.json err
                if !dialog
                    res.status 500
                    return res.json err:msg:"Dialog not found or not active"
                _params.to = dialog.client
                console.log "TO SEND params ",_params
                TwilioService.sendSMS( _params, (err,message)->
                    console.log 'is send message', message
                    ##TODO: replace demo operator
                    _.extend message , { dialog : dialog.id, operator: 1}
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
                            dialog.save()
                            return res.json entity

                    )
                )
        )
    ## calback url for status send SMS
    statusMessage:  (req,res)->
        _params = req.params.all()
        console.log '===> status',_params
        ##TODO: add controll sussce status
        Messages.findOne(sid:_params.SmsSid).exec(
            (err,entity)->
                if err
                    res.status 500
                    return res.json err

                if !entity
                    res.status 418
                    return res.json {message:"Ooops! Entity is NULL. "}

                entity.status = _params.SmsStatus
                entity.save(
                    (err,smsInfo)->
                        ##TODO: change scructure
                        console.log 'info',smsInfo
                        if err
                            return res.json err
                        if !smsInfo
                            res.status 418
                            return res.json {message:"Ooops! SMS information is NULL"}
                        return res.json smsInfo
                )

        )
    ## client messages registration

    clientMessage: (req,res)->
        _params = req.params.all()
        console.log 'client send as messages',_params
        Conversations.findOrCreate({AccountSid:_params.AccountSid,client:_params.From,isactive:true},{client:_params.From, AccountSid:_params.AccountSid,isWaitAnswer:true}).exec(
            (err,dialog)->
                if err
                    return res.json err
                console.log "findeOrCreate Conversations(Dialog)",dialog
                dialog.isWaitAnswer = true
                _params.dialog = dialog.id
                Messages.create(_params,(err,savedMessage)->
                    if err
                        return res.json err
                    if !savedMessage
                        res.status 418
                        return res.json {message:"Ooops! SMS information not saved"}
                    ## send information all subscibers  how work
                    ##sails.sockets.broadcast(savedMessage.AccountSid,'messages',  {data: savedMessage });
                    dialog.save()
                    return res.json savedMessage

                )
        )

}