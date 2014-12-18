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
        User.create
            #username: username
            firstname: firstname
            lastname: lastname
            password: password
            email: email
            role: 'Operator' ##NOTE: hardcode role name 'Operator'
        , (err, user) ->
            if err
                if err.code is "E_VALIDATION"
                    if err.invalidAttributes.email
                        req.flash "error", "Error.Passport.Email.Exists"
                    else
                        req.flash "error", "Error.Passport.User.Exists"
                return next(err)
            #            Passport.create
            #                protocol: "local"
            #                password: password
            #                user: user.id
            #            , (err, passport) ->
            #                if err
            #                    req.flash "error", "Error.Passport.Password.Invalid"  if err.code is "E_VALIDATION"
            #                    return user.destroy((destroyErr) ->
            #                        next destroyErr or err
            #                        return
            #                    )
            #                #next null, user
            #                return res.json(user,201)
            #            return
            Email.send(
                to: [
                    name: user.username
                    email: user.email
                ]
                subject: 'Operator Registration CrosLinkMedia SMSChat'
                html:
                    'You was registered as Operator <a href="#test">LIKT TO SITE</a><br/>'+
                    "You login\password : #{user.email}/#{password}"
                text: 'You was registry '
                (err)->
                    #                // If you need to wait to find out if the email was sent successfully,
                    #                // or run some code once you know one way or the other, here's where you can do that.
                    #                // If `err` is set, the send failed.  Otherwise, we're good!
                    console.log 'is send OK or' , err
                    if err
                        res.status 418
                        user.destroy((destroyErr) ->
                                    next destroyErr or err
                                    return
                        )
                        return res.json msg: "email not send",err

                    return res.json(user,201)
                )
            #return res.json(user,201)
        return




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
            User.count(role:'Operator').exec(
                (error, count)->
                    if (error)
                        res.status 500
                        return res.json error
                    else
                        User.find(role:'Operator').sort(_sort).paginate(paginateCriteria).exec(
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