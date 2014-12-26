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
            Conversations.count().exec(
                (error, count)->
                    if (error)
                        res.status 500
                        return res.json(error)
                    else
                        Conversations.find().sort(_sort).paginate(paginateCriteria).populate('msgs',messageCriteria).populate('operator').exec(
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
    ###
    start dialog between Operator and Client
    ###
    setOperator: (req,res)->
        console.log 'Conversations:setOperator', req.token
        ## get current
        _id = req.param('id')


        Conversations.findOne(id:_id).populate('operator').exec(
            (err,entity)->
                console.log 'find' , entity
                if err
                    res.status 500
                    return res.json err
                if !entity
                    return res.json err:msg:"Conversation not found"
                ## check current operator
                if entity.operator?
                    ##TODO: delete dublicate call
                    Conversations.findOne(id:_id).populate('operator').exec(
                        (err, dialog)->
                            if err
                                return res.json err
                            return res.json dialog
                        )

                else
                    entity.operator = req.token.sid
                    entity.isWaitAnswer = true
                    entity.save(
                        (err)->
                            if err
                                return res.json err
                            Conversations.findOne(id:_id).populate('operator').exec(
                                (err, dialog)->
                                    if err
                                        return res.json err
                                     ##send auto response
                                    _params =
                                        ##TODO: account sid req.token
                                        to : entity.client
                                        ## TODO: template  #%OPERATOR_NAME% is here to help you”
                                        body: format "{OPERATOR_NAME} is here to help you", OPERATOR_NAME:"#{dialog.operator.firstname} #{dialog.operator.lastname}" # "Operator #{dialog.operator.firstname} #{dialog.operator.lastname} is here to help you"
                                    TwilioService.sendSMS( _params, (err,message)->
                                        _.extend message , { dialog : dialog.id, operator: 0}
                                        if err
                                            res.status 500
                                            return res.json err
                                        Messages.create(message).exec(
                                            (err,entity)->
                                                #if err
                                                #    res.status 500
                                                #    return res.json err
                                                #if !entity
                                                #    res.status 418
                                                #    return res.json err
                                                #return res.json entity

                                        )
                                    )

                            ##TODO: delete dublicate call



                                    return res.json dialog
                            )

                    )
                    #res.status 418
                    #return res.json entity
        )

}