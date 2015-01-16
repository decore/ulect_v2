###*
* ConversationsController
* @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
format = require("string-template")
module.exports = {
    index: (req,res)->

        return res.json "index"
    ###
    FIND
    ###
    find: (req,res,next)->
        _token = req.token
        User.findOne(id:_token.sid).exec( (err,currentUser)->
            if err
                return res.json err
            _AccountSid = currentUser.AccountSid
            id = req.param('id')
            if (id == 'find' or id == 'update' or id == 'create' or id == 'destroy')
                return next();
            if id
                Conversations.findOne(id).exec(
                    (err,entity)->
                        if err
                            return next(err)
                        return res.json(entity);
                )
            else
                _get_params = req.params.all()
                paginateCriteria =
                    page: 1
                    limit: 100
                _sort =
                    id: "desc"
                paginateCriteria.page =  _get_params.page if !!_get_params.page
                paginateCriteria.limit =  _get_params.limit if !!_get_params.limit
                _sort = JSON.parse(_get_params.sort) if !!_get_params.sort

                messageCriteria =
                    # limit: 5
                    sort : 'createdAt asc'
                    where: {}
                Conversations.count(isactive:true, AccountSid:_AccountSid).exec(
                    (error, count)->
                        if (error)
                            res.status 500
                            return res.json(error)
                        else
                            Conversations.find(isactive: true, AccountSid:_AccountSid).sort(_sort).paginate(paginateCriteria).populate('msgs',messageCriteria).populate('operator').exec(
                                (err,entities)->
                                    if err
                                        res.status 500
                                        return res.json err
                                    #                                if req.isSocket == false
                                    #                                    res.setHeader('X-Prism-Total-Items-Count', count)
                                    #                                else
                                    #                                    Conversations.subscribe(req.socket,entities,['update']);
                                    return res.json(entities)
                            )
                )
        )
    ###
    start dialog between Operator and Client
    ###
    setOperator: (req,res)->
        console.log 'Conversations:setOperator'
        _token = req.token
        ## get current
        _id = req.param('id')

        Conversations.findOne(id:_id).populate('operator').exec(
            (err,entity)->
                console.log 'find' , entity
                if err
                    res.status 500
                    return res.json err
                if !entity
                    return res.json err:"Conversation not found",msg:"Conversation not found"
                ## check current operator
                if entity.operator?
                    ##TODO: delete dublicate call
                    Conversations.findOne(id:_id).populate('operator').exec(
                        (err, dialog)->
                            if err
                                res.status 500
                                return res.json err
                            return res.json dialog
                        )

                else
                    entity.operator = _token.sid ##NOTE: User
                    entity.isWaitAnswer = true
                    entity.save(
                        (err)->
                            if err
                                res.status 500
                                return res.json err

                            Conversations.findOne(id:_id).populate('operator').exec(
                                (err, dialog)->
                                    if err
                                        res.status 500
                                        return res.json err
                                        ##send auto response
                                    console.log "  OPERATOR ", dialog.operator
                                    console.log  format( '{OPERATOR_NAME} is here to help you', {OPERATOR_NAME: dialog.operator.firstname+ " " + dialog.operator.lastname})
                                    _params =
                                        ##TODO: account sid req.token
                                        to : entity.client
                                        ## TODO: template  #%OPERATOR_NAME% is here to help you”
                                        body: dialog.operator.firstname+ " " + dialog.operator.lastname + ' is here to help you'
                                        #    format '{OPERATOR_NAME} is here to help you', {OPERATOR_NAME: dialog.operator.firstname+ " " + dialog.operator.lastname}
                                        # "Operator #{dialog.operator.firstname} #{dialog.operator.lastname} is here to help you"

                                    User.findOne(id:_token.sid).exec((err,currentUser)->
                                        #console.log "currentUser ",currentUser
                                        if err or !currentUser
                                            res.status 500
                                            return res.json err: "User not found", msg: "Service error"

                                        TwlAccount.findOne(sid:currentUser.AccountSid).exec((err,twlAccount)->
                                            if err or !twlAccount
                                                 res.status 500
                                                 return res.json msg: "Service error"
                                            _params.AccountSid = currentUser.AccountSid
                                            _params.authToken= twlAccount.authToken
                                            #console.log "TwlAccount ",_params
                                            TwlPhoneNumber.findOne(accountSid:currentUser.AccountSid).exec((err,twlPhone)->
                                                console.log "twlPhone ",twlPhone
                                                if err or !twlPhone
                                                   res.status 500
                                                   return res.json err:"Phone no exists",msg: "Service error"
                                                _params.from =  twlPhone.phoneNumber
                                                console.log "TwlPhoneNumber ",_params
                                                TwilioService.sendSMS( _params, (err,message)->
                                                    _.extend message , { dialog : dialog.id, operator: 0}
                                                    console.log 'is send message', message
                                                    ##TODO: replace demo operator
                                                    _.extend message , { dialog : dialog.id, operator: 0 }
                                                    console.log 'is extend message===', message
                                                    if err
                                                        res.status 500
                                                        return res.json err

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
                                        )
                                    )#->User.findOne


                                    #                                    TwilioService.sendSMS( _params, (err,message)->
                                    #                                        _.extend message , { dialog : dialog.id, operator: 0}
                                    #                                        if err
                                    #                                            res.status 500
                                    #                                            return res.json err
                                    #                                        Messages.create(message).exec(
                                    #                                            (err,entity)->
                                    #                                                #if err
                                    #                                                #    res.status 500
                                    #                                                #    return res.json err
                                    #                                                #if !entity
                                    #                                                #    res.status 418
                                    #                                                #    return res.json err
                                    #                                                #return res.json entity
                                    #                                        )
                                    #                                    )

                                    ##TODO: delete dublicate call
                                    return res.json dialog
                            )

                    )
        )

}