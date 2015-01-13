###*
* @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
passport = require("passport");
jwt = require('jsonwebtoken');
secret = 'ewfn09qu43f09qfj94qf*&H#(R';
format = require("string-template")
moment = require('moment');
module.exports = {
    #login: (req,res)->
    #    res.json "ok"
    #    login: (req, res) ->
    #        passport.authenticate("local", (err, user, info) ->
    #
    #            if (err) or (not user)
    #                res.send
    #                    success: false
    #                    message: "invalidPassword"
    #
    #                return
    #            else
    #                if err
    #                    res.send
    #                        success: false
    #                        message: "unknownError"
    #                        error: err
    #
    #                else
    #                    token = jwt.sign(user, secret,
    #                        expiresInMinutes: 60 * 24
    #                    )
    #                    res.send
    #                        success: true
    #                        user: user
    #                        token: token
    #
    #            return
    #        ) req, res
    #        return

    logout: (req, res) ->
        console.log 'logout'
        req.logout()
        User.findOne(id:req.param('id')).exec(
            (err, user)->
                console.log user
                if user?.isLogin? and user.isLogin == true
                    user.isLogin = false
                    user.save()
        )
        res.send
            success: true
            message: "logoutSuccessful"

        return
    ## API call
    authenticate :(req, res) ->
        email = req.param("email")
        password = req.param("password")
        if not email or not password
            return res.json(401,
                err: "username and password required"
            )
        User.findOneByEmail email, (err, user) ->
            unless user
                return res.json(401,
                    err: "invalid username or password"
                )
            if user.activated == false
                return res.json 403, err: "Account not activated"

            User.validPassword password, user, (err, valid) ->
                if err
                    return res.json(403,
                        err: "forbidden"
                    )
                unless valid
                    res.json 401,
                        err: "invalid username or password"
                else
                    user.isLogin = true
                    user.save()
                    #TODO: FIX FIND PHONE
                    Profile.findOne().where( 'owner.AccountSid':user.AccountSid).populate('owner').exec(
                        (err, profile)->
                            console.log profile,user.AccountSid
                            if err or !!!profile
                                _phoneNumber='no phone'
                            else
                               _phoneNumber = profile.phoneNumber

                            res.json

                                user: _.extend user.toJSON(),phoneNumber: _phoneNumber
                                token: sailsTokenAuth.issueToken(sid: user.id,AccountSid:user.AccountSid,role:user.role)
                    )
                return
            return
        return
    ##TODO: delete
    _register : (req, res) ->
        console.log _params = req.params.all()
        return res.json
            user: {id:20}
            token: sailsTokenAuth.issueToken(sid: 20 ,AccountSid:'',role:'Administrator')
    ## API call - Customer Registration
    register : (req, res) ->
        crosslinkmedia = sails.config.crosslinkmedia
        issueDate = moment().utc().format()
        console.log _params = req.params.all()
        #TODO: Do some validation on the input
        if _params.password isnt _params.confirmPassword
            return res.json(400,
                err: "Password doesn't match"
            )
        if !_params.email
            return res.json(400,
                err: "Email doesn't set"
            )
        ##NOTE: create user and make it active
        User.create(
            email: _params.email
            password: _params.password
            firstname:  _params.firstname
            lastname:  _params.lastname
            isLogin: false ##TODO: change this. Make user isLogin after login
        ).exec(
            (err, user)->
                if err
                    res.status err.status
                    return res.json  err: err
                if user
                    console.log 'user.username'
                    #delete user.username
                    delete user.password
                    _params.owner = user.id
                    if _params.country?
                        _params.country = ISO:_params.ISO, Country:_params.Country
                    Profile.create(_params).exec(
                        (err,profile)->
                            console.log profile
                            ##
                            if err
                                console.log 'profile err',err
                                User.destroy(user)
                                res.status 500#err.status
                                return res.json err
                            else
                                Email.send(
                                    to: [
                                        name: _params.username
                                        email: _params.email
                                    ]
                                    subject: 'Confirm Email address to complete registration' ##CrosLinkMedia SMSChat
                                    html:
                                        format 'Hello! <br>'+
                                        'You have registered on the site CLM.com. In order to complete the registration of your account at this Email address, click on the link:<br/><br/>'+
                                        '<a href="{LINKVERIFICATE}">{LINKVERIFICATE}</a>'+
                                        '<br> If you did not register on the site CLM.com, please ignore this letter.',{ USERNAME: user.username ,LINKVERIFICATE: crosslinkmedia.siteURL+"/activate?token="+sailsTokenAuth.issueToken(sid: user.id,email:user.email,expiresInMinutes: 1,issue:issueDate)}
                                    text: 'You need confirm registration '
                                    (err)->
                                        #                // If you need to wait to find out if the email was sent successfully,
                                        #                // or run some code once you know one way or the other, here's where you can do that.
                                        #                // If `err` is set, the send failed.  Otherwise, we're good!
                                        console.log 'is send OK or' , err
                                        res.status 418
                                        return res.json msg: "is send",err
                                )
                                res.status 201
                                return res.json
                                    user: user
                                    token: sailsTokenAuth.issueToken(sid: user.id,AccountSid:user.AccountSid,role:user.role)
                    )

                return
        )
        return
    ## activate account and create
    activate: (req,res)->
        #account.sid
        params = req.params.all()
        sails.log.debug('activation action');
        User.findOne( {id: params.id, activationToken: params.token}, (err, user)->
            ##
            if err
                sails.log.debug(err);
                res.json 'err',err
            else
                if !user
                    res.status 404
                    res.json msg:'user not fount'
                else
                    TwilioService.createSubAccount(FriendlyName:user.email,(err,account)->
                        if err
                            res.status err.status
                            res.json err
                        else
                            user.AccountSid = account.sid
                            user.status = account.status
                            res.json user
                    )
                    #res.json user
        )
        #        ##Activate the user that was requested.
        #        token = cryptoService.token(req.param('token'))
        #        sails.log.debug('token',token);
        #        #        User.update( {id: params.id, activationToken: params.token }, { activated: true} , (err, user)->
        #        #            ##Error handling
        #        #            if (err)
        #        #              sails.log.debug(err);
        #        #              res.send(500, err);
        #        #             # Updated users successfully!
        #        #            else
        #        #              sails.log.debug("User activated:", user);
        #        #              #res.redirect('/');
        #        #              return res.json  req.params.all()
        #        #        )
        #        cryptoService.compare('test', token, (err,res)->
        #                sails.log.debug('compate=',res);
        #
        #        )
        #        return res.json  token, req.params.all()
    ## get API key
    apikey: (req,res)->
        User.findOne(id:req.token.sid ).exec(
            (err, user)->
                if err
                    res.json err
                else
                    if !user
                        res.status 401
                        res.json err: "User not found "
                    else
                        res.json key:user.AccountSid

        )
    ## Password forgot API (RF07 - Resetting password)
    forgotpassword:(req,res)->
        crosslinkmedia = sails.config.crosslinkmedia
        issueDate = moment().utc().format()
        console.log 'issueDate', issueDate
        _email = req.param('email')
        User.findOne(email:_email).exec( (err,user)->
            if err
                res.status err.status
                res.json err:err, user_msg: "Not found"
            else
                if !user
                    res.status 400
                    return res.json user_msg: "Email not found"
                console.log
                user  = user.toJSON()
                Email.send(
                    to: [
                        name: user.username
                        email: user.email
                    ]
                    subject: 'Function to reset the password' ##CrosLinkMedia SMSChat
                    html:
                        #format 'For confirm registration go to url <a href="#test">LIKT TO SITE</a><br/>'

                        format 'Hello! <br/>'+ #"{USERNAME},"+
                            "You use the password reset. If you have forgotten your password, click on the link to reset your password: <br/><br/>"+
                            '<a href="{LINKVERIFICATE}">{LINKVERIFICATE}</a>'+
                            "<br/>If you do not need to reset the password, please ignore this letter."+
                            #                            "Someone has asked to reset the password for your account.<br/>" +
                            #                            "If you did not request a password reset, you can disregard this email."+
                            #                            "No changes have been made to your account."+
                            #                            "<br/>To reset your password, follow this link (or paste into your browser):<br/>"+
                            "{LINKVERIFICATE}",{ USERNAME: user.username ,LINKVERIFICATE: crosslinkmedia.siteURL+"/reset-verification?token="+sailsTokenAuth.issueToken(sid: user.id,email:user.email,expiresInMinutes: 60,issue:issueDate)}
                    text: 'Password reset'
                    (err)->
                        #                // If you need to wait to find out if the email was sent successfully,
                        #                // or run some code once you know one way or the other, here's where you can do that.
                        #                // If `err` is set, the send failed.  Otherwise, we're good!
                        if err
                            res.status 418
                            res.json user_msg:  "Error! Please try again.",
                        else
                            res.json user_msg: format "An email has been sent to {EMAIL} with further instructions on resetting your password.",EMAIL:user.email
                )
        )
    ##
    updatepassword:(req,res)->
        token = req.param('token')
        now = moment().utc()
        if !req.param('token')
            return res.json(400, {err: 'No Authorization token was found'});

        sailsTokenAuth.verifyToken(req.param('token'), (err, token)->
            if err
                return res.json(400, {err: 'Token verify error'});
            _email = token.email
            console.log token

            User.findOneByEmail(_email, (err,user)->
                if err
                    res.status 500
                    res.json err
                else

                    #user.save(
                    res.json
                        user: user
                        token: sailsTokenAuth.issueToken(sid: user.id,AccountSid:user.AccountSid,role:user.role)
            )
        )
    changePassword:(req,res)->
        console.log req.params.all(),req.token
        token =req.token
        if !req.token
            return res.json(400, {err: 'Token verify error'});
        _email = token.email
        console.log token
        #password: "test"
        #passwordConfirm: "ss"
        #passwordOld:
        email = req.param("email")
        password = req.param("password")
        passwordOld = req.param("passwordOld")
        passwordConfirm = req.param("passwordConfirm")
        if not passwordOld or not password
            return res.json(400,
                user_msg: "Password is required"
            )
        if passwordConfirm != password
            return res.json(400,
                user_msg: "Password and passwordConfirm not equal "
            )

        User.findOne id:token.sid , (err, user) ->
            console.log user
            unless user
                return res.json(400,
                    user_msg: "invalid password "+token.sid
                )
            #if user.activated == false
            #    return res.json 403, err: "Account not activated"

            User.validPassword passwordOld, user, (err, valid) ->
                console.log err,valid
                if err
                    return res.json err
                unless valid
                    res.json 400,
                        user_msg: "invalid password"
                else
                    user.isLogin = true
                    user.save(password:password)
                    res.json
                        user: user.toJSON()
                        token: sailsTokenAuth.issueToken(sid: user.id,AccountSid:user.AccountSid,role:user.role)

                return
            return
        return
        #res.status 501
        #res.json
        #    user_msg: "ERROR"
        #    token: req.token
}