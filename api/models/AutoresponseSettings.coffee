 # AutorespondSettings.coffee
    #
    # @description :: TODO: You might write a short summary of how this model works and what it represents here.
    # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =

    attributes: {
        AccountSid: "string"
        #        owner:
        #            model: "Profile"
        #            via: 'id'
        AR1:
            type: "string"
            defaultsTo: "Hello, welcome to our support center. Operator will contact you shortly."
        AR2:
            type: "string"
            defaultsTo: "Please keep waiting. Our operator will contact you shortly"

    }
