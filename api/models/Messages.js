/**
 * Messages.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/#!documentation/models
 */

module.exports = {
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
        "dialog": {
            model: "Conversations"
        },
        "operator": {
            type: 'json'
        }
    },
//    toJSON:function(){
//        
//    },
    beforeValidation: function (values, cb) {
        if (values.Account_sid){
            values.AccountSid  = values.Account_sid;
            delete values.Account_sid;
        }
        if (values.body){
            values.Body  = values.body;
            delete values.body;
        }
        User.findOne({id: values.operator}).exec(
                function (err, user) {
                    if (err)
                        return cb();
                    //console.log('===beforeValidation==================== user', values.operator, user);
                    if (user)
                        values.operator = user.toJSON();

                    cb();
                });
    },
//    beforeValidate: function (values, cb) {
//        console.log('===beforeValidate==message ', values);
//        if (values.Account_sid){
//            values.AccountSid  = values.Account_sid;
//            delete values.Account_sid;
//        }
//        if (values.body){
//            values.Body  = values.body;
//            delete values.body;
//        }
//        
//        cb();
//    },
    // 
    beforeCreate: function (values, cb) {
        //console.log('beforeCreate: values', values);
        cb();
    },
    afterCreate: function (values, cb) {
        sails.sockets.broadcast(values.AccountSid, 'messages', {verb:'create',data: values});
        //sails.sockets.broadcast(values.account_sid, 'messages:create', {data: values});
        cb();
    },
    afterUpdate: function (values, cb) {
        sails.sockets.broadcast(values.AccountSid, 'messages', {verb:'update',data: values});
        //console.log('Messages:afterUpdate: values', values);
        cb();
    }

};

