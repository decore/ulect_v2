 # TwlAccount.coffee
    #
    # @description :: TODO: You might write a short summary of how this model works and what it represents here.
    # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =

    attributes: {
        sid:
            type: "string"
            required: true
        ownerAccountSid:
            type: "string"
            required: true
        friendlyName:
            type: "string"
            required: true
        status:
            type: "string"
            required: true
        type: # "Full"
            type: "string"
            required: true
        authToken:
            type: "string"
            required: true
    }
 