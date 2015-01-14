###*
* OperatorsController
*
* @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
##TODO: delete demo OPERATORS

module.exports = {
    index: (req,res)->
        return res.json {}
    ###
    CREATE Operator
    ###
    create :(req, res, next) ->
        _token = req.token
        User.findOne(id:_token.sid).exec( (err,currentUser)->
            if err
                return res.json err
            _AccountSid = currentUser.AccountSid
            console.log 'Conversations:setOperator', req.token
            _token = req.token
            email = req.param("email")
            firstname = req.param("firstname")
            lastname = req.param("lastname")
            password = req.param("password")
            #password = generatePassword(12, false, /\d/) ##TODO: password generate?
            unless email
                req.flash "error", "Error.Passport.Email.Missing"
                return next(new Error("No email was entered."))
            unless firstname
                req.flash "error", "Error.Passport.Firstname.Missing"
                return next(new Error("No firstname was entered."))
            unless lastname
                req.flash "error", "Error.Passport.Lastname.Missing"
                return next(new Error("No lastname was entered."))
            unless password
                req.flash "error", "Error.Passport.Password.Missing"
                return next(new Error("No password was entered."))
            #        unless city
            #            req.flash "error", "Error.Registration.City.Missing"
            #            return next(new Error("No city support was entered."))
            User.findOne(id: _token.sid,).exec(
                (err, userCustomer)->
                    if err
                        res.status 500
                        ##TODO: client validation message
                        return res.json
                            msg: "Operation access error"
                            err:err
                    User.create
                        #username: username
                        firstname: firstname
                        lastname: lastname
                        password: password
                        email: email
                        AccountSid: userCustomer.AccountSid
                        role: 'Operator' ##NOTE: hardcode role name 'Operator'
                    , (err, user) ->
                        if err
                            if err.code is "E_VALIDATION"
                                if err.invalidAttributes.email
                                    req.flash "error", "Error.Passport.Email.Exists"
                                else
                                    req.flash "error", "Error.Passport.User.Exists"
                            return next(err)
                        ##
                        Email.send(
                            to: [
                                name: user.username
                                email: user.email
                            ]
                            subject: 'Operator Registration CrosLinkMedia(SMSChat)'
                            html:
                                'You was registered as Operator in CrosLinkMedia(SMSChat)<br/>'+
                                "login: #{user.email} <br/>"+
                                "password: #{password}"
                            text: 'Registration Operator CrosLinkMedia'
                            (err)->
                                if err
                                    res.status 418
                                    user.destroy((destroyErr) ->
                                        next destroyErr or err
                                        return
                                    )
                                    return res.json msg: "email not send",err:err
                                ## Activated user account
                                user.activated = true
                                user.save(
                                    (err)->
                                        if err
                                            res.status 500
                                            user.destroy()
                                            return res.json
                                                err: err
                                                msg: "Error: Update error "
                                        res.status 201
                                        return res.json  user.toJSON()
                                )
                            )
            )
        )
    ##active operators list
    ###
    Operators list
    ###
    find:  (req,res)->
        _token = req.token
        id = req.param('id')

        User.findOne(id:_token.sid).exec( (err,currentUser)->
            if err
                return res.json err
            console.log 'token currentUser',_token,currentUser
            _AccountSid = currentUser.AccountSid
            if (id == 'find' or id == 'update' or id == 'create' or id == 'destroy')
                return next();
            ##
            if id
                User.findOne(id:id,role:'Operator',AccountSid:_AccountSid ).exec(
                    (err,user)->
                        if err
                            res.status err.status
                            return  res.json(err)#next(err)
                        if !user
                            res.status 403
                            return res.json msg:"Operator not found or delete"
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
                User.count(role:'Operator',AccountSid:_AccountSid).exec(
                    (error, count)->
                        if (error)
                            res.status 500
                            return res.json error
                        else
                            User.find(role:'Operator',AccountSid:_AccountSid).sort(_sort).paginate(paginateCriteria).exec(
                                (err,userList)->
                                    if err
                                        res.status 500
                                        return res.json err
                                    res.setHeader('X-Prism-Total-Items-Count', count)
                                    return res.json(userList)
                            )
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
