 # TwlAddress.coffee
    #
    # @description :: TODO: You might write a short summary of how this model works and what it represents here.
    # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =

    attributes: {
        sid:
            type: "string"
            required: true
        accountSid:
            type: "string"
            required: true
        friendlyName:
            type: "string"
            required: true
        customerName:
            type: "string"
            defaultsTo: "none"
        postalCode:
            type: "string"
            defaultsTo: "none"
        isoCountry:
            type: "string"
            required: true
    }
