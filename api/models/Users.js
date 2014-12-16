/**
 * Users.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/#!documentation/models
 */

module.exports = {
    attributes: {
        username: {
            
            type: "string",
            defaultsTo: "New Operator"
        },
        //TODO: delete default value
        AccountSid: {
            type: "string",
            required: true,
            defaultsTo: "AC220dd9ec0df20b77d7cdd306ee34f43a"
        },
        isLogin: {
            type: "boolean",
            defaultsTo: false
        },
        role: {
            type: "string",
            enum: ['Admin', 'Owner', 'Operator'],
            defaultsTo: 'Operator'
        }
    },
    afterCreate: function (values, cb) {
        if (values.role === 'Operator') {
            sails.sockets.broadcast(values.AccountSid, 'operator', {verb: 'create', data: values});
        }
        cb();
    },
    afterUpdate: function (values, cb) {
        if (values.role === 'Operator') {
            sails.sockets.broadcast(values.AccountSid, 'operator', {verb: 'update', data: values});
        }

        cb();
    }
};

