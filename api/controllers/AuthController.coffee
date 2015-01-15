###*
* @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
passport = require("passport");
jwt = require('jsonwebtoken');
secret = 'ewfn09qu43f09qfj94qf*&H#(R';
format = require("string-template")
moment = require('moment');
module.exports = {
    ##
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
                    return res.json 401,
                        err: "invalid username or password"
                else
                    user.isLogin = true
                    user.save()
                    #TODO: FIX FIND PHONE
                    #Profile.findOne().where( 'owner.AccountSid':user.AccountSid).populate('owner').exec(
                    TwlPhoneNumber.findOne().where(accountSid: user.AccountSid).exec(
                        (err, phoneNumber)->
                            if err or !phoneNumber?
                                _phoneNumber= 'error find phone'
                            else
                                _phoneNumber = phoneNumber.phoneNumber

                            return res.json
                                user: _.extend user.toJSON(),phoneNumber: _phoneNumber
                                token: sailsTokenAuth.issueToken(sid: user.id,AccountSid:user.AccountSid,role:user.role)
                    )

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
                            "<br/>If you do not need to reset the password, please ignore this letter.",{ USERNAME: user.username ,LINKVERIFICATE: crosslinkmedia.siteURL+"/reset-verification?token="+sailsTokenAuth.issueToken(sid: user.id,email:user.email,expiresInMinutes: 60,issue:issueDate)}
                            #                            "Someone has asked to reset the password for your account.<br/>" +
                            #                            "If you did not request a password reset, you can disregard this email."+
                            #                            "No changes have been made to your account."+
                            #                            "<br/>To reset your password, follow this link (or paste into your browser):<br/>"+
                            #"{LINKVERIFICATE}",{ USERNAME: user.username ,LINKVERIFICATE: crosslinkmedia.siteURL+"/reset-verification?token="+sailsTokenAuth.issueToken(sid: user.id,email:user.email,expiresInMinutes: 60,issue:issueDate)}
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
    ###*
    * Update User password
    ###

    updatepassword:(req,res)->
        token = req.param('token')
        now = moment().utc()
        if !req.param('token')
            return res.json(400, {err: 'No Authorization token was found'});
        sailsTokenAuth.verifyToken(req.param('token'), (err, token)->
            if err
                return res.json(400, {msg: "Token verify error" ,err: 'Token verify error'});
            _email = token.email
            _password = req.param("password")
            passwordConfirm = req.param("passwordConfirm")

            if passwordConfirm != _password
              return res.json(400, msg: "Password and password confirm not equal ")

            User.findOneByEmail(_email, (err,user)->
                if err
                    res.status 500
                    res.json err
                else
                    user.activated == true if user.activated == false
                    user.isLogin = true
                    user.password = _password
                    user.save((err)->
                        if err
                            res.status 500
                            return res.json err:err,msg:"Service error"
                        else
                            return res.json
                                user: user
                                token: sailsTokenAuth.issueToken(sid: user.id,AccountSid:user.AccountSid,role:user.role)
                    )
            )
        )
    ###*
    * function changePassword User Password
    ###
    changePassword:(req,res)->
        _token = req.token
        if !_token
            res.status 400
            return res.json { err: "Auth error",msg:'Token verify error'}
        email = req.param("email")
        password = req.param("password")
        passwordOld = req.param("passwordOld")
        passwordConfirm = req.param("passwordConfirm")
        if not passwordOld or not password
            res.status 400
            return res.json
                err: "Password is required"
                msg: "Password and password confirm not equal "

        if passwordConfirm != password
            res.status 400
            return res.json
                err: "Password and passwordConfirm not equal "
                msg: "Password and passwordConfirm not equal "

        User.findOne id:_token.sid , (err, user) ->
            console.log user
            unless user
                res.status 404
                return res.json
                    msg: "Use  password "

            #if user.activated == false
            #    return res.json 403, err: "Account not activated"

            User.validPassword passwordOld, user, (err, valid) ->
                console.log err,valid
                if err
                    res.status 500
                    return res.json err
                unless valid
                    res.status 400
                    res.json
                        msg: "Invalid old password"
                else
                    user.password = password
                    user.save((err)->
                        if err
                            res.status 500
                            return res.json err
                        return res.json
                            msg: "Password change success"
                            user: user.toJSON()
                            token: sailsTokenAuth.issueToken(sid: user.id,AccountSid:user.AccountSid,role:user.role)
                    )

}
