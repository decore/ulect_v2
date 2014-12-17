###*
* OperatorsController
*
* @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
##TODO: delete demo OPERATORS

module.exports = {
    index: (req,res)->
        return res.json {}
    ##active operators list
    ###
    Operators list
    ###
    find:  (req,res)->
        id = req.param('id')
        if (id == 'find' or id == 'update' or id == 'create' or id == 'destroy')
            return next();
        ##
        if id
            User.findOne(id:id,role:'Operator').exec(
                (err,user)->
                    if err
                        res.status err.status
                        return  res.json(err)#next(err)
                    if !user
                        res.status 403
                        return res.json msg:"Operator not fount or delete"
                    return res.json(user);
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
            console.log _sort
            User.count().exec(
                (error, count)->
                    if (error)
                        res.status 500
                        return res.json error
                    else
                        User.find().sort(_sort).paginate(paginateCriteria).exec(
                            (err,userList)->
                                if err
                                    res.status 500
                                    return res.json err
                                res.setHeader('X-Prism-Total-Items-Count', count)
                                return res.json(userList)
                        )
            )
    ###
    UPDATE
    ###
    update: (req,res,next)->
        id = req.param('id');
        criteria = {}
        ##TODO: add field controll (model?)
        criteria = _.merge({}, req.params.all(), req.body);
        if !id
            return res.badRequest('No id provided.');
        else
            User.update(id,criteria)
                #.populateAll()#('role')
                .exec(
                    (err,users)->
                        if err
                            res.status err.status
                            return res.json(err);
                        if users.length == 0
                           res.status 404
                           return res.json  msg:"Operator not found or delete"
                        User.findOne(id).exec(
                            (err,user)->
                                if err then return next(err)
                                return res.json(user);
                        )
            )
    ###
    DESTROY
    ###
    destroy: (req, res, next)->
        id = req.param('id')
        if !id
            return res.badRequest(error:msg:'No id provided.');
        else
            User.findOne(id).exec(
                (err,user)->
                    if (err) then return res.serverError(err);

                    if (!user) then return res.notFound();

                    User.destroy(id).exec(
                        (err)->
                            if (err) then return next(err);
                            return res.json(user);
                    )
            )
}