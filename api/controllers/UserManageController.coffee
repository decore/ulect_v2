# UserManageController
#
# @description :: Server-side logic for managing Usermanages
# @help        :: See http://links.sailsjs.org/docs/controllers
moment = require 'moment'
format = require 'string-template'

validateRegistrationData = (model = {},cb)->
    _.forEach model, (item,key)->
        console.log '---', item,key
    cb(null,model)

module.exports = {
    ###*
    * API - Customer Registration
    ###
    register : (req, res) ->
        ## systemSettings
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
                msg: "Email doesn't set"
            )
        if _params.email.length > 64
            return res.json(400,
                err: "Sorry, but email must be less 64 charatees"
                msg: "Sorry, but email must be less 64 charatees"
            )

        #        if _params.companyname.length == 0
        #            return res.json(400,
        #                err: "Sorry, but Company name must be less 64 charatees"
        #                msg: "Sorry, but Company name must be less 64 charatees"
        #            )
        #        companyname: "Nikolay Gerzhan"
        #
        #        isoCountry: "US"
        #
        #        firstname: "NIkolay"
        #        lastname: "G"
        #        password: "demo123456"
        #        phone: "+79832877503"
        #        role: "Administrator"
        ## create a Twilio SubAccount
        ## required param FriendlyName
        User.create(
            AccountSid: null
            email: _params.email
            password: _params.password
            firstname:  _params.firstname
            lastname:  _params.lastname
            role: "Administrator"
            isLogin: false ##TODO: change this. Make user isLogin after login
        ).exec(
            (err, user)->
                if err
                    _msg = req.__("ERROR:SERVICE:DEFAULT")
                    if err.code is "E_VALIDATION"
                        if err.invalidAttributes?.email?
                            _.forEach err.invalidAttributes.email , (item)->
                                _msg = req.__("ERROR:VALIDATION:EMAIL:EXISTS", item.value) if item.rule is "unique"
                        else
                            req.flash "error", "Error.Passport.User.Exists"
                            _msg= "Please, check fields"
                    res.status err.status
                    return res.json
                        err: err
                        msg: _msg
                if user
                    delete user.password
                    _params.owner = user.id
                    Profile.create(_params).exec(
                        (err,profile)->
                            #console.log profile
                            ##
                            if err
                                console.log 'profile err',err


                                User.destroy(user)
                                res.status 500 #err.status
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
        )
    ###*
    * API - Activate Customer Account and Registry Twilio SubAccount
    ###
    activate: (req,res)->
        _params =req.params.all()
        console.log _params
        ##
        if _params.apiKey? and _params.token?
            _where =
                APIkey: _params.apiKey
                activationToken: _params.token
            User.findOne(_where).then(
                (user)->
                    ##NOTE: Profile seaching user
                    profile = Profile.findOne(owner:user.id).then(
                        (_profile)-> return _profile
                    )
                    return [user,profile]
            ).spread( ## User information
                (user,profile)->
                    console.log user,profile
                    if user.activated == true ## user information find Error
                        res.status 404
                        return res.json
                            err:"User not found"
                            msg:"Error activation! User not found or already activated"

                    ## Start Activate SubAccount
                    TwilioService.createSubAccount(FriendlyName:user.email, (err,accountTwilio)->
                        if err
                            res.status 400
                            err =
                                err: "API service error"
                                msg: "Sorry! API call error"
                            return res.json err
                        else
                            ##NOTE: clear data before save
                            delete accountTwilio.subresourceUris
                            delete accountTwilio.subresource_uris
                            ##NOTE: save local Twilio Account information
                            TwlAccount.findOrCreate(sid: accountTwilio.sid, accountTwilio, (err, twlAccount)->
                                if err
                                    console.log "ERROR CREATE ", err
                                    res.status = 500
                                    err=
                                        err: "Service error"
                                        msg: "Service error"
                                    return res.json err
                                else
                                    ## Create(add) Addres on Twilio Account
                                    TwilioService.createOrUpdateAddress(twlAccount, profile.isoCountry, (err,address)->
                                        if err
                                            return res.json err
                                        ## Save Address in system
                                        TwlAddress.findOrCreate(sid: address.sid, address, (err, address)->
                                            console.log "addressList", address
                                            if err or !address ## Address not save - Twilio Regustration is a Faild
                                                err =
                                                    err: "Service Address registration faild"
                                                    msg: "Sorry! Update Address error. Registration is faild"
                                                res.status = 500
                                                return res.json err
                                            TwilioService.activeSubAccountPhone({areaCode:null, isoCountry:address.isoCountry, accountSid:twlAccount.sid , authToken:twlAccount.authToken}, (err, incomingPhoneNumber)->
                                                if err
                                                    res.status 500
                                                    return res.json
                                                        err: "Account activation error"
                                                        msg: "Sorry! Please, try to late"
                                                ##NOTE: Local Save(create) PhoneNumber information
                                                TwlPhoneNumber.findOrCreate(sid:incomingPhoneNumber.sid,incomingPhoneNumber, (err, twlPhoneNumber)->
                                                    if err
                                                        ## TODO: client info message
                                                        return res.json err
                                                    ## ACTIVATION WORKFLOW SUCCESS
                                                    user.activated = true
                                                    user.AccountSid = twlAccount.sid
                                                    ##TODO: Profile update
                                                    _params.phoneNumber = twlPhoneNumber.sid
                                                    user.save((err)->
                                                        if err
                                                            ##TODO: do client  error message
                                                            err:err
                                                            msg: "Activation faild."
                                                            return res.json err
                                                        if err or !twlPhoneNumber.phoneNumber?
                                                            _phoneNumber= 'error find phone'
                                                        else
                                                            _phoneNumber = twlPhoneNumber.phoneNumber

                                                        return res.json
                                                            user: _.extend user.toJSON(),phoneNumber: _phoneNumber
                                                            token: sailsTokenAuth.issueToken(sid: user.id,AccountSid:user.AccountSid,role:user.role)
                                                            msg: "Activation success."
                                                    )
                                                )
                                            )
                                        )
                                    )
                            )
                    )
                    #                    return res.json
                    #                        user: user
                    #                        profile:profile
            ).fail(## User.findOne
                (err)->
                    if err ## System Error
                        res.status = 500
                        return res.json  ## user information find Error
                            profile: profile
                            err:"User not found"
                            msg:"Error activation! User not found or already activated"

            )
        else
            res.status 400
            return res.json
                err: "Params not found"
                msg: "Activation parameters not found"

}
