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
            console.log
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
        req.logout()
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
            User.validPassword password, user, (err, valid) ->
                if err
                    return res.json(403,
                        err: "forbidden"
                    )
                unless valid
                    res.json 401,
                        err: "invalid username or password"

                else
                    res.json
                        user: user
                        token: sailsTokenAuth.issueToken(sid: user.id)

                return
            return
        return
    ## API call
    register : (req, res) ->
        console.log _params = req.params.all()

        #TODO: Do some validation on the input
        if _params.password isnt _params.confirmPassword
            return res.json(401,
                err: "Password doesn't match"
            )
        User.create(
            email: _params.email
            password: _params.password

        ).exec (err, user) ->
            if err
                res.json err.status,
                    err: err 
                return
            if user
                delete user.password
                res.json
                    user: user
                    token: sailsTokenAuth.issueToken(sid: user.id)

            return

        return
}