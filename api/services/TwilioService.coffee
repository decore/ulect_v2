##Load the twilio module
twilio = require('twilio');

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
## Creating Subaccounts https://www.twilio.com/docs/api/rest/subaccounts#creating-subaccounts
exports.createAccount = (options,cb)->
    config = sails.config.twilio
    client = new twilio.RestClient(config.TWILIO_ACCOUNT_SID, config.TWILIO_AUTH_TOKEN)

    console.log 'createAccount',options
    if !options.FriendlyName
        err = status:400, message: "No set FriendlyName for new account"
        cb(err,null)
    else
        client.accounts.list( friendlyName: options.FriendlyName ,(err,data)->
            console.log data
            if data.accounts.length !=1
                err = status : 400, msg :  "Account not found"
                #                    client.accounts.create(FriendlyName:options.FriendlyName, (err,account)->
                #                         cb(err,account)
                #                    )
                cb(err,null)
            else
                cb(null,data.accounts[0])

        )
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
# https://www.twilio.com/docs/api/rest/subaccounts#exchanging-numbers
exports.transferPhoneNumber  = (options,cb)->
    ##NOTE: Master Account only
    config= sails.config.twilio
    console.log config 
    _options = {
        phoneNumber: options.phoneSid || ""
        accountSid: options.newAccountSid || ""
    }

    client = new twilio.RestClient(config.TWILIO_ACCOUNT_SID, config.TWILIO_AUTH_TOKEN)
    client.incomingPhoneNumbers(_options.phoneNumber).update( accountSid: _options.accountSid , (err, number)->
            #process.stdout.write(number);
            console.log err,number
            cb(err, number)
    )