###*
* ConversationsController
* @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
module.exports = {
    index: (req,res)->
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
                limit: 10
            _sort =
                id: "desc"
            paginateCriteria.page =  _get_params.page if !!_get_params.page
            paginateCriteria.limit =  _get_params.limit if !!_get_params.limit
            _sort = JSON.parse(_get_params.sort) if !!_get_params.sort
            Conversations.count().exec(
                (error, count)->
                    if (error)
                        res.status 500
                        return res.json(error)
                    else
                        Conversations.find().sort(_sort).paginate(paginateCriteria).populate('msgs').exec(
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

}