###*
* @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
passport = require("passport");
jwt = require('jsonwebtoken');
secret = 'ewfn09qu43f09qfj94qf*&H#(R';
module.exports = {
    #login: (req,res)->
    #    res.json "ok"
    login: (req, res) ->
        passport.authenticate("local", (err, user, info) ->

            if (err) or (not user)
                res.send
                    success: false
                    message: "invalidPassword"

                return
            else
                if err
                    res.send
                        success: false
                        message: "unknownError"
                        error: err

                else
                    token = jwt.sign(user, secret,
                        expiresInMinutes: 60 * 24
                    )
                    res.send
                        success: true
                        user: user
                        token: token

            return
        ) req, res
        return

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
                    res.json
                        user: user
                        token: sailsTokenAuth.issueToken(sid: user.id,AccountSid:user.AccountSid,role:user.role)

                return
            return
        return
    register : (req, res) ->
        console.log _params = req.params.all()
        return res.json
            user: {id:20}
            token: sailsTokenAuth.issueToken(sid: 20 ,AccountSid:'',role:'Administrator')
    ## API call - Customer Registration
    _register : (req, res) ->
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
            isLogin: true ##TODO: change this. Make user isLogin after login
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

                    Profile.create(_params).exec(
                        (err,profile)->
                            console.log profile
                            ##
                            if err
                                console.log 'profile err',err
                                res.status err.status
                                return res.json err
                            Email.send(
                                to: [
                                    name: _params.username
                                    email: _params.email
                                ]
                                subject: 'New Account Acivation Required  ' ##CrosLinkMedia SMSChat
                                html:
                                    'For confirm registration go to url <a href="#test">LIKT TO SITE</a><br/>'
                                text: 'You need confirm registration '
                                (err)->
                                    #                // If you need to wait to find out if the email was sent successfully,
                                    #                // or run some code once you know one way or the other, here's where you can do that.
                                    #                // If `err` is set, the send failed.  Otherwise, we're good!
                                    console.log 'is send OK or' , err
                                    res.status 418
                                    return res.json msg: "is send",err
                            )
                            res.status 403 if !user.activated
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
                    TwilioService.createAccount(FriendlyName:user.email,(err,account)->
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
}