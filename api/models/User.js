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
        // account Sid from Tilio
        AccountSid: {
            type: "string",
            required: true
            // defaultsTo: "AC220dd9ec0df20b77d7cdd306ee34f43a"// 'ACc0d344677835c0a303c92d59cfa1b9d8'//"AC220dd9ec0df20b77d7cdd306ee34f43a"
        },
        isLogin: {
            type: "boolean",
            defaultsTo: false
        },
        // confirm activation account 
        activated: {
            type: "boolean",
            defaultsTo: false
        },       
        activationToken: {
            type: "string"
        },
        status: {
            type: 'string',
            enum: ['closed', 'suspended', 'active'],
            defaultsTo: 'suspended'
        },
        role: {
            type: "string",
            enum: ['Administrator', 'Owner', 'Operator'],
            defaultsTo: 'Administrator'
                    //required: true
        },
        toJSON: function () {
            var obj = this.toObject();
            obj.username = this.getUserName();
            delete obj.encryptedPassword;
            //delete obj.AccountSid; 
            //delete obj.activationToken;
            return obj;
        },
        country: {
            model: "Country",
            via: "ISO"
        },
        APIkey: {
            type: "string"
        },
        APItoken: {
            type: "string"
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
                values.activated = false; //make sure nobody is creating a user with activate set to true, this is probably just for paranoia sake :)
                var _time = new Date().getTime();
                values.activationToken = cryptoService.token(_time + values.email);
                values.APIkey = cryptoService.genAPIkey(_time + values.email);
                values.APItoken = sailsTokenAuth.issueToken({email: values.email});
                //cryptoService.genAPIkey(new Date().getTime() + values.email);
                next(null, values);
            });
        });
    },
    beforeUpdate: function (values, next) {
        console.log("Before update");
        if (values.password) {
            bcrypt.genSalt(10, function (err, salt) {
                if (err)
                    return next(err);
                console.log(values.password);
                bcrypt.hash(values.password, salt, function (err, hash) {
                    if (err)
                        return next(err);
                    values.encryptedPassword = hash;
                    //values.activated = false; //make sure nobody is creating a user with activate set to true, this is probably just for paranoia sake :)
                    //values.activationToken = cryptoService.token(new Date().getTime() + values.email);
                    //values.APIkey = cryptoService.genAPIkey(new Date().getTime() + values.email);
                    next(null, values);
                });
            });
        } else {
            next(null, values);
        }
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
                        cb(null, values);
                    });
        } else {
            cb(null, values);
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
                        cb(null, values);
                    });
        } else {
            cb(null, values);
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

