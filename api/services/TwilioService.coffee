###
#
###
twilio = require('twilio'); ##Load a official twilio module
##
# Create a new REST API client to make authenticated requests against the
#twilio back end
#client = new twilio.RestClient(sails.config.twilio.TWILIO_ACCOUNT_SID, config.TWILIO_AUTH_TOKEN)

###
REST API: Messages https://www.twilio.com/docs/api/rest/message
Send Message
###
exports.sendSMS =  (options,cb)->
    config = sails.config.twilio

    client = new twilio.RestClient(config.TWILIO_ACCOUNT_SID, config.TWILIO_AUTH_TOKEN)
    ##TODO: add controll "options" parameter API key
    #console.log 'TwilioSrvice:sendSMS(',options,')'
    if options.body
        ##NOTE: hook for debug
        #options.to = '+79832877503'#'+79504328892'#
        console.log 'sms for client ', options.to
    else
        error = message: "is EMPTY message"
        cb(error,null)
    sms_messages_options =
        to: options.to#'+79832877503'#'+79504328892'#
        from: config.TWILIO_NUMBER
        body: options.body #'Hi from Nikolay :) and Twilio'
        StatusCallback: config.StatusCallback ##NOTE: web-application settings for get information about changes a status of SMS
    ## Pass in parameters to the REST API using an object literal notation. The
    ## REST client will handle authentication and response serialzation for you.

    #client.sms.messages.create(sms_messages_options,(err,message)->
    ##or
    client.sendSms(sms_messages_options,(error,message)->
        # The HTTP request to Twilio will run asynchronously. This callback
        # function will be called when a response is received from Twilio
        # The "error" variable will contain error information, if any.
        # If the request was successful, this value will be "falsy"
        cb(error,message)
        #            if !error
        #                # The second argument to the callback will contain the information
        #                # sent back by Twilio for the request. In this case, it is the
        #                # information about the text messsage you just sent:
        #                console.log('Success! The SID for this SMS message is:');
        #                console.log(message.sid);
        #
        #                console.log('Message sent on:');
        #                console.log(message.dateCreated);
        #            else
        #                console.log('Oops! There was an error.');

    )
##https://www.twilio.com/docs/api/rest/available-phone-numbers

exports.availablePhoneNumbers = (options,cb)->
    config = sails.config.twilio
    options = {
        isoCode: 'US'
    }
    client = new twilio.RestClient(config.TWILIO_ACCOUNT_SID, config.TWILIO_AUTH_TOKEN)

    #https://www.twilio.com/docs/api/rest/available-phone-numbers#local
    #SmsEnabled:true
    client.availablePhoneNumbers(options.isoCode).mobile.list({},cb)


##
exports.messagesList = (options,cb)->
    config = sails.config.twilio
    client = new twilio.RestClient(config.TWILIO_ACCOUNT_SID, config.TWILIO_AUTH_TOKEN)

    client.messages.list(options,(err, data)->
        console.log data
        #        data.messages.forEach (message)->
        #            console.log(message.friendlyName);
        cb(err, data)
    )
###*
* Creating Subaccounts for new Custormer
* 64 characters
* only 1000 subaccount by default (for more - https://www.twilio.com/help/contact)
* @url info: https://www.twilio.com/docs/api/rest/subaccounts#creating-subaccounts
###
exports.createSubAccount = (options,cb)->
    ## get systemSettings
    _masterAccountSettings = sails.config.twilioMasterAccount
    ## Master Account client
    client = new twilio.RestClient(_masterAccountSettings.TWILIO_ACCOUNT_SID, _masterAccountSettings.TWILIO_AUTH_TOKEN)
    ## semple check params
    if !options.FriendlyName
        err =
            status:400
            err: "No set FriendlyName for new sub account"
        return cb(err,null)
    if options.FriendlyName.length > 64
        err =
            status:400
            err: "FriendlyName for new sub account must be less 64 characters"
        return cb(err,null)
    else
        ## create twilio sub account
        client.accounts.create(FriendlyName:options.FriendlyName, (err,account)->
            ## error created a new SubAccount
            if err
                ##try to find an exists SubAccount
                client.accounts.list( friendlyName: options.FriendlyName ,(err,data)->
                   ## The account not created and not found
                   if err || data.accounts.length !=1
                       err =
                            status : 500
                            msg :  "Service error! Try to late!"
                       cb(err,null)
                   else
                       cb(null,data.accounts[0])
                )
            else
                ## The SubAccount was success created
                cb(null,account)
        )

###*
*  Activate subaccount
*  - check Status
*  - incominPhoneNumber
https://www.twilio.com/docs/api/rest/incoming-phone-numbers#list-get
###
exports.activeSubAccountPhone = (options,cb)->
    ## get systemSettings
    _masterAccountSettings = sails.config.twilioMasterAccount
    _systemSettings = sails.config.crosslinkmedia
    ## SubAccount data
    if options.accountSid?
        client = new twilio.RestClient(options.accountSid, _masterAccountSettings.TWILIO_AUTH_TOKEN)

        client.incomingPhoneNumbers.list( (err,data)->
            if err
                console.log '!!!',options.accountSid,err
                return cb(err,null)
            ## Client is Already have PhoneNumber
            if data.incoming_phone_numbers.length > 0
                console.log 'incoming_phone_numbers',data.incoming_phone_numbers
                cb(null,data.incoming_phone_numbers[0])
            else
                ## by new phone number
                _options =
                    areaCode: option.areaCode ## require field
                    smsFallbackMethod: "POST",
                    smsFallbackUrl: _systemSettings.smsFallbackUrl,
                    smsMethod: "POST",
                    smsUrl: _systemSettings.smsUrl
                    statusCallback:_systemSettings.statusCallback
                clientMaster = new twilio.RestClient(_masterAccountSettings.TWILIO_ACCOUNT_SID, _masterAccountSettings.TWILIO_AUTH_TOKEN)
                clientMaster.incomingPhoneNumbers.create(  _options , (err, number)->
                    #process.stdout.write(number);
                    console.log 'was by a Phone number',err,number
                    if err
                        cb(err, null)
                    else
                        if number?
                            client.incomingPhoneNumbers(number.sid).update({}, (err, number)->
                                console.log("Was create",number.sid);
                                cb(null, number)
                            )
                        else
                            err =
                                status: 500
                                err: "Error by phone"
                                msg: "Sorry! Service error"
                            cb(err,null)
                )
        )
    else
        err=
            status: 400
            err: "accountSid not found"
            msg: "Params not found"
        cb(err, null)




## Closing a Subaccount https://www.twilio.com/docs/api/rest/subaccounts#closing-subaccounts
exports.destroyAccount = (options,cb)->
    config = sails.config.twilio
    client = new twilio.RestClient(config.TWILIO_ACCOUNT_SID, config.TWILIO_AUTH_TOKEN)
    ## POST 'Status' with the value 'closed'
    cb(err,data)
###
Buy Number - buy number like Master Account
###
exports.buyNumber  = (options,cb)->
    config= {
        TWILIO_ACCOUNT_SID: 'ACf05f511ddc69d343935861aedb799742',
        TWILIO_AUTH_TOKEN: '9df8a9b345ded148b21f48e9852ef37e',
        TWILIO_NUMBER: "+15005550006",
        StatusCallback: 'http://78921f6d.ngrok.com/api/v1/messages/status'
    }

    _options = {
        phoneNumber: "+15005550006"
        friendlyName: "friendlyNameForPhoneNumber_Conpany_Name"
        SmsUrl: "http://78921f6d.ngrok.com/api/v1/messages/client/15005550006"#http://78921f6d.ngrok.com/api/v1/messages/client/16505675330?number=16505675330&Sid=PN3866b432d55f214107706f1d3357b9b9
        SmsMethod: 'POST'
        SmsFallbackUrl:  'http://78921f6d.ngrok.com/api/v1/messages/client/fallback'
        SmsFallbackMethod: 'POST'
    }

    client = new twilio.RestClient(config.TWILIO_ACCOUNT_SID, config.TWILIO_AUTH_TOKEN)
    client.incomingPhoneNumbers.create(  _options , (err, number)->
            #process.stdout.write(number);
            console.log err,number
            cb(err, number)
    )
###*
*
*
* https://www.twilio.com/docs/api/rest/subaccounts#exchanging-numbers
###
exports.transferPhoneNumber  = (options,cb)->
    ## get systemSettings
    _systemSettings = sails.config.twilioMasterAccount
    console.log config
    _options = {
        phoneNumber: options.phoneSid || ""
        accountSid: options.newAccountSid || ""
    }

    client = new twilio.RestClient(_systemSettings.TWILIO_ACCOUNT_SID, _systemSettings.TWILIO_AUTH_TOKEN)
    client.incomingPhoneNumbers(_options.phoneNumber).update( accountSid: _options.accountSid , (err, number)->
            #process.stdout.write(number);
            console.log err,number
            cb(err, number)
    )