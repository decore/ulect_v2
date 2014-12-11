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
    ## method add(send) new message (POST request)
    newMessage: (req,res)->
        _params = req.params.all()
        ##TODO: API key controll
        ##TODO: API SID controll
        console.log '===> newMessages',_params
        TwilioService.sendSMS( _params, (err,message)->
            Messages.create(message).exec(
                (err,entity)->
                    if err
                        res.status 500
                        return res.json err

                    if !entity
                        res.status 418
                        return res.json err
                    return res.json entity

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
                    return res.json {message:"Ooops! Entity is NULL"}
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
        _params = rq.params.all()
        console.log 'client messages',_params
        return res.json req.params.all()
}