/**
 * User.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/#!documentation/models
 */
var bcrypt = require('bcryptjs');

module.exports = {
    schemas: true,
    attributes: {
        firstname: {
            type: "string",
            defaultsTo: "First name"
        },
        lastname: {
            type: "string",
            defaultsTo: "New Last name"
        },
//        username: {
//            type: "string",
//            defaultsTo: "New Operator"
//        },
        getUserName: function () {
            return this.firstname + ' ' + this.lastname;
        },
        email: {
            type: 'string',
            required: true,
            unique: true
        },
        encryptedPassword: {
            type: 'string'
        },
        // 
        AccountSid: {
            type: "string",
            required: true,
           // defaultsTo: "AC220dd9ec0df20b77d7cdd306ee34f43a"// 'ACc0d344677835c0a303c92d59cfa1b9d8'//"AC220dd9ec0df20b77d7cdd306ee34f43a"
        },
        isLogin: {
            type: "boolean",
            defaultsTo: false
        },
        isConfirm: {
            type: "boolean",
            defaultsTo: false
        },
        role: {
            type: "string",
            enum: ['Administrator', 'Owner', 'Operator'],
            defaultsTo: 'Administrator',
            //required: true
        },
        toJSON: function () {
            var obj = this.toObject();
            obj.username = this.getUserName();
            delete obj.encryptedPassword;
            //delete obj.AccountSid; 
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
            User.findOne(values).exec(
                    function (err, values) {
                        if (err)
                            return cb(err); 
                        console.log('create send -------');
                        sails.sockets.broadcast(values.AccountSid, 'operator', {verb: 'create', data: values, dt: new Date()});
                        cb();
                    });
        } else {
            cb();
        }
    },
    //
    afterUpdate: function (values, cb) {
        if (values.role === 'Operator') { 
         User.findOne(values).exec(
                    function (err, values) {
                        if (err)
                            return cb(err); 
                        console.log('update send -------');
                        sails.sockets.broadcast(values.AccountSid, 'operator', {verb: 'update', data: values, dt: new Date()});
                        cb();
                    });
        } else {
            cb();
        }
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

