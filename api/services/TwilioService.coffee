##Load the twilio module
twilio = require('twilio');
##
config =
    # Account twilio.crosslinksms@gmail.com
#    TWILIO_ACCOUNT_SID: 'AC220dd9ec0df20b77d7cdd306ee34f43a'
#    TWILIO_AUTH_TOKEN :'f702406810816dab63eb2fe7e5001961'
#    TWILIO_NUMBER:'+16505675330'
    # TEST Account
        TWILIO_ACCOUNT_SID: 'ACf05f511ddc69d343935861aedb799742',
        TWILIO_AUTH_TOKEN :'9df8a9b345ded148b21f48e9852ef37e',
        TWILIO_NUMBER:'+15005550006'

# Create a new REST API client to make authenticated requests against the
#twilio back end
client = new twilio.RestClient(config.TWILIO_ACCOUNT_SID, config.TWILIO_AUTH_TOKEN)

###
REST API: Messages https://www.twilio.com/docs/api/rest/message
Send Message
###
exports.sendSMS =  (options,cb)->
    console.log 'TwilioSrvice:sendSMS(',options,')'
    sms_messages_options =
        to:'+79832877503'#'+79504328892'#
        from: config.TWILIO_NUMBER
        body: 'Hi from Nikolay :) and Twilio'

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