 # Message.coffee
    #
    # @description :: TODO: You might write a short summary of how this model works and what it represents here.
    # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =

    attributes: {
        "AccountSid": "string", # group room
        "Body": "string",       # text
        "status": "string",     # remote state
        "dateCreated": "date",  # remote create
        "dateUpdated": "date",  # remote update
        "conversation": "integer",
        "fromUser": {
            type: "integer",
            defaultsTo: null
        },

    }
    afterCreate:  (values, cb) ->
        sails.log.info("Message.afterCreate: ");
        ## если сообщение от клиента или отправлено системой
        ## отправить авто ответ
        Jobs.create('checkAutoSendAR2',values).delay(5000).priority('high').save(
            (err)->
                console.log "task 'checkAutoSendAR2' err is ",err
        )
        Jobs.promote();
        cb();

