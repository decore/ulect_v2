 # Message.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =

  attributes: {
        "sid": "string",
        "AccountSid": "string",
        "To": "string",
        "From": "string",
        "Body": "string",
        "Status": "string",
        "dateCreated": "date",
        "dateUpdated": "date",
        "conversation": "integer",
  }
