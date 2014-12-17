##Load the twilio module
twilio = require('twilio');
##
config =
    # Account twilio.crosslinksms@gmail.com
    TWILIO_ACCOUNT_SID: 'AC220dd9ec0df20b77d7cdd306ee34f43a'
    TWILIO_AUTH_TOKEN :'f702406810816dab63eb2fe7e5001961'
    TWILIO_NUMBER:'+16505675330'
    StatusCallback: 'http://newspaper-plan.cloudapp.net:8080/api/v1/messages/status'
    # TEST Account
    #        TWILIO_ACCOUNT_SID: 'ACf05f511ddc69d343935861aedb799742',
    #        TWILIO_AUTH_TOKEN :'9df8a9b345ded148b21f48e9852ef37e',
    #        TWILIO_NUMBER:'+15005550006'
    ## DEMO Settings for deploy in  http://crosslinkmedia.tk:8080 - account Brad
    #    TWILIO_ACCOUNT_SID: 'ACc0d344677835c0a303c92d59cfa1b9d8'
    #    TWILIO_AUTH_TOKEN :'e6dc7e7cceed05eedf5e644975cab642'
    #    TWILIO_NUMBER:'+18303550804'
    #    StatusCallback: 'http://crosslinkmedia.tk:8080/api/v1/messages/status'
# Create a new REST API client to make authenticated requests against the
#twilio back end
client = new twilio.RestClient(config.TWILIO_ACCOUNT_SID, config.TWILIO_AUTH_TOKEN)

###
REST API: Messages https://www.twilio.com/docs/api/rest/message
Send Message
###
exports.sendSMS =  (options,cb)->
    ##TODO: add controll "options" parameter API key
        console.log 'TwilioSrvice:sendSMS(',options,')'
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
            if !error
                # The second argument to the callback will contain the information
                # sent back by Twilio for the request. In this case, it is the
                # information about the text messsage you just sent:
                console.log('Success! The SID for this SMS message is:');
                console.log(message.sid);

                console.log('Message sent on:');
                console.log(message.dateCreated);
            else
                console.log('Oops! There was an error.');

        )
##https://www.twilio.com/docs/api/rest/available-phone-numbers

exports.availablePhoneNumbers = (options,cb)->

    client.availablePhoneNumbers().all.list({  },cb)


##
exports.messagesList = (options,cb)->
    client.messages.list(options,(err, data)->
        console.log data
        #        data.messages.forEach (message)->
        #            console.log(message.friendlyName);
        cb(err, data)
    )

