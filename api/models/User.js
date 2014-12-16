/**
 * User.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/#!documentation/models
 */
var bcrypt = require('bcryptjs');

module.exports = {
    schema: true,

    attributes: {
        username: {
            type: "string",
            defaultsTo: "New Operator"
        },
        email: {
            type: 'string',
            required: true,
            unique: true
        },
        encryptedPassword: {
            type: 'string'
        },
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
        },
        toJSON: function () {
            var obj = this.toObject();
            delete obj.encryptedPassword;
            delete obj.AccountSid;
            return obj;
        }
    },
    beforeCreate: function (values, next) {
        bcrypt.genSalt(10, function (err, salt) {
            if (err)
                return next(err);

            bcrypt.hash(values.password, salt, function (err, hash) {
                if (err)
                    return next(err);

                values.encryptedPassword = hash;
                next();
            });
        });
    },
    //
    afterCreate: function (values, cb) {
        if (values.role === 'Operator') {
            sails.sockets.broadcast(values.AccountSid, 'operator', {verb: 'create', data: values});
        }
        cb();
    },
    //
    afterUpdate: function (values, cb) {
        if (values.role === 'Operator') {
            sails.sockets.broadcast(values.AccountSid, 'operator', {verb: 'update', data: values});
        }

        cb();
    },
    //
    validPassword: function (password, user, cb) {
        bcrypt.compare(password, user.encryptedPassword, function (err, match) {
            if (err)
                cb(err);

            if (match) {
                cb(null, true);
            } else {
                cb(err);
            }
        });
    }
};

