 # UserManageController
    #
    # @description :: Server-side logic for managing Usermanages
    # @help        :: See http://links.sailsjs.org/docs/controllers
moment = require 'moment'
format = require 'string-template'

module.exports = {
    ###*
    * API - Customer Registration
    ###
    register : (req, res) ->
        ## systemSettings  Master Account
        _systemSettings = sails.config.crosslinkmedia
        _issueDate = moment().utc().format()
        _params = req.params.all()
        #TODO: Do some validation on the input
        if _params.password isnt _params.confirmPassword
            return res.json(400,
                err: "Password doesn't match"
            )
        if !_params.email
            return res.json(400,
                err: "Email doesn't set"
            )
        if _params.email.length > 64
            return res.json(400,
                err: "Sorry, but email must be less 64 charatees"
            )
        ## create a Twilio SubAccount
        ## required param FriendlyName
        TwilioService.createSubAccount(FriendlyName:_params.email, (err,accountTwilio)->
            if err
                return res.json err
            console.log 'accountTwilio',accountTwilio
            User.create(
                AccountSid: accountTwilio.sid
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
                                #console.log profile
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
                                            '<br> If you did not register on the site CLM.com, please ignore this letter.',{ USERNAME: user.username ,LINKVERIFICATE: _systemSettings.siteURL+"/activate/"+user.APIkey+"?token="+user.activationToken}
                                        text: 'You need confirm registration '
                                        (err)->
                                            #                // If you need to wait to find out if the email was sent successfully,
                                            #                // or run some code once you know one way or the other, here's where you can do that.
                                            #                // If `err` is set, the send failed.  Otherwise, we're good!
                                            console.log 'is send OK or' , err
                                            ##TODO: create logger errors send emain (table in DB for resending)
                                            if err
                                                res.status 418
                                            return res.json msg: "is send"
                                    )
                                    res.status 201
                                    return res.json
                                        user: user
                                        token: sailsTokenAuth.issueToken(sid: user.id,AccountSid:user.AccountSid,role:user.role)
                        )

                    return
            )
            return
        )
    ###*
    * API - Activate Customer Account
    ###
    activate: (req,res)->
        _params =req.params.all()
        console.log _params
        ##
        if _params.apiKey? and _params.token?
            _where =
                APIkey: _params.apiKey
                activationToken: _params.token
            User.findOne(_where).exec((err,user)->
                if err ## System Error
                    return res.json err
                console.log 'user', user
                if !user ## Data find Error
                   res.status 404
                   return res.json
                        err:"User not found"
                        msg:"Error activation! User not fount or already activated"
                res.status 200
                ## Start Activate SubAccount
                console.log 'Activate AccountSid', user.AccountSid
                Profile.findOne(owner:user.id).exec( (err,profile)->
                    if err
                        return res.json err
                    if !profile
                        res.status = 404
                        return res.json
                            err: "Profile notfound"
                            msg: "Service error. User profile not found"

                    TwilioService.activeSubAccountPhone(areaCode: null,accountSid:user.AccountSid, (err, incomingPhoneNumber)->
                        if err
                            res.status 500
                            return res.json
                                err: "Account activation error"
                                msg: "Sorry! Please, try to late"
                        console.log 'incomingPhoneNumber',incomingPhoneNumber

                        ## TODO: save to profile
                        ## TODO: save staus activate for current user
                        return res.json
                            user: user
                            incomingPhoneNumber: incomingPhoneNumber
                    )
                )
            )
        else
            res.status 400
            return res.json
                err: "Params not found"
                msg: "Activation parameters not found"

}
