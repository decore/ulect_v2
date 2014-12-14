/**
 * Conversations.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/#!documentation/models
 */

module.exports = {
    attributes: {
        AccountSid: {
            type: "string",
            required: true
        },
        client: {
            type: "string",
            required: true
        },
        operator: {
            model: 'Users',
            defaultsTo: null
        }
        ,
        isactive: {
            type: "boolean",
            defaultsTo: true
        },
        msgs: {
            collection: 'Messages',
            via: 'dialog'
        },
        isWaitAnswer:{
            type: "boolean",
            defaultsTo: true
        }
    },
//    beforeValidation: function (values, cb) {        
//        Messages.find({AccountSid:values.AccountSid,dialog: values.id}).limit(1).sort('id DESC').exec(
//                function (err, lastMessage) {
//                    console.log('Conversation:beforeValidation:lastMessage', values.AccountSid, values.id,lastMessage);
//                    if (err)
//                        return cb();
//                   
//                    if (lastMessage){
//                        values.isWaitAnswer = (lastMessage.From === values.client); 
//                    }else{
//                        values.isWaitAnswer = false;
//                    }
//                    cb();
//                });
//    },
    // after create  
    afterCreate: function (newValues, cb) {
        
        sails.sockets.broadcast(newValues.AccountSid, 'conversations', {verb: "create", data: newValues});
        cb();
    },
    afterUpdate: function (values, cb) {
        console.log('Conversations:afterUpdate: values', values);
//        if (values.operator) {
//            Users.findOne({id: values.operator}).exec(function (err, operator) {
//                if (err) {
//
//                }
//                else {
//                    values.operator = operator;
//                    sails.sockets.broadcast(values.AccountSid, 'conversations', {verb: "update", data: values});
//                }
//            });
//        }
        Conversations.findOne(values).populate('operator').exec(function (err, dialog) {
            if (!!dialog.operator) {
               delete dialog.operator.AccountSid;
               delete dialog.operator.role;
            }   
            sails.sockets.broadcast(dialog.AccountSid, 'conversations', {verb: "update", data: dialog});
        });
        cb();
    }
};

