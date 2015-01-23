/**
 * Kue job queue holder
 *
 * Queue will be loaded into this object in bootstrap.js
 */
module.exports = {
    _processors: {
        /**
         * Send password reset email
         */

        sendPasswordResetEmail: function (job, cb) {
            if (!job.data.user)
                return cb(new Error("User not provided"));
            var user = new User._model(job.data.user);
            user.sendPasswordResetEmail(function (err, res, msg) {
                cb(err, res, msg);
            });
        },
        /**
         * 
         * @returns {undefined}
         */
        sendAR2: function (job, cb) {
            console.log(job.id, job.data);
            //get last message 
            Messages.findOne({id: job.data.id}).exec(
                    function (err, msg) {
                        if (err)
                            return cb(new Error("Error serach Message"));
                        setTimeout(function () {
                            console.log("OK is send AR2", msg);
                            Jobs.create("sendSMS", job.data).save(
                                    function () {
                                        console.log("Start AR2 33333 for  ", job.data);
                                        cb(null, msg);
                                    }
                            )
                            //  cb(null, msg);
                        }, 3000);
                    }
            )
//            .fail(
//                    function () {
//                        cb(new Error("Error serach Messages"));
//                    }
//            )

        },
        sendSMS: function (job, cb) {
            console.log(job.id, job.data);
            Messages.findOne({id: job.data.id}).then(
                    function (msgs) {
                        console.log("Must to send ", job.data);
                        cb(null, msgs);
//                        Jobs.create("sendAR2", job.data).save(
//                                function () {
//                                    console.log("Start AR2 for  ", job.data);
//                                    cb(null, msgs);
//                                }
//                        )

                    }
            ).fail(
                    function () {
                        cb(new Error("Error serach Messages"));
                    }
            )

        },
        /**
         * 
         * @param {type} job
         * @param {type} cb
         * @returns {undefined}
         */
        autoSendAR1: function (job, cb) {
            var _delayTimeMS = 10000;
            // job.data.id =  id сообщение которое должно быть последним для отправки автореспонса   
            // job.data.dialog = id dialog который должен быть активным 
            console.log('autoSendAR1', job.data);
            // Получение настроек аккаунта
            TwilioService.getTwlAccountData({AccountSid: job.data.AccountSid}, function (err, subAccountData) {
                if (err) {
                    cb(new Error("Error get Twilio Params"));
                }
                else {
                    var _paramAutoresponseSettings = {
                        AccountSid: subAccountData.AccountSid
                    }
                    // 
                    AutoresponseSettings.findOne(_paramAutoresponseSettings).exec(
                            function (err, _autoresponseSettings) {
                                var _sendParam = {
                                    AccountSid: subAccountData.AccountSid,
                                    authToken: subAccountData.authToken,
                                    from: subAccountData.phoneNumber,
                                    to: job.data.From,
                                    body: _autoresponseSettings.AR1};
                                // отправка смс на твилио
                                TwilioService.sendSMS(_sendParam, function (err, autoresponseSMS) {
                                    if (!err) {
                                        //##res.json sendSMS
                                        autoresponseSMS.dialog = job.data.dialog;
                                        // сохранить в БД 
                                        Messages.create(autoresponseSMS, function (err, savedMessageNew) {
                                            if (!err) {
                                                // Jobs.create("autoSendAR2", savedMessageNew).save();
                                                Jobs.create('autoSendAR2', savedMessageNew).delay(_delayTimeMS).priority('high').save();
                                            }
                                        });
                                        cb();
                                    }
                                });
                            });
                }
            })
        },
        autoSendAR2: function (job, cb) {
            var _delayTimeMS = 10000;
            // job.data.id =  id сообщение которое должно быть последним для отправки автореспонса   
            // job.data.dialog = id dialog который должен быть активным 
            console.log('autoSendAR2', job.data);
            Messages.findOne({dialog: job.data.dialog}).sort({createdAt: 'desc'}).populate("dialog").exec(
                    function (err, data) {
                        if (err) {
                            return cb(new Error("Find message"));
                        }
                        console.log(data);
                        if ((data.id).toString() === job.data.id) {
                            // получить данные для отправки сообщения 
                            // twlAccount , AR2 для аккаунта 
                            TwilioService.getTwlAccountData({AccountSid: job.data.AccountSid}, function (err, subAccountData) {
                                if (err) {
                                    cb(new Error("Error get Twilio Params"));
                                }
                                else {
                                    var _paramAutoresponseSettings = {
                                        AccountSid: subAccountData.AccountSid
                                    }
                                    // 
                                    AutoresponseSettings.findOne(_paramAutoresponseSettings).exec(
                                            function (err, _autoresponseSettings) {
                                                var _sendParam = {
                                                    AccountSid: subAccountData.AccountSid,
                                                    authToken: subAccountData.authToken,
                                                    from: subAccountData.phoneNumber,
                                                    to: job.data.From,
                                                    body: _autoresponseSettings.AR2}; ///AR2
                                                // отправка смс на твилио
                                                TwilioService.sendSMS(_sendParam, function (err, autoresponseSMS) {
                                                    if (!err) {
                                                        //##res.json sendSMS
                                                        autoresponseSMS.dialog = job.data.dialog;
                                                        // сохранить в БД 
                                                        Messages.create(autoresponseSMS, function (err, savedMessageNew) {
                                                            if (!err) {
                                                                // Jobs.create("autoSendAR2", savedMessageNew).save();
                                                                Jobs.create('autoSendAR2', savedMessageNew).delay(_delayTimeMS).priority('high').save();
                                                            }
                                                        });
                                                        cb();
                                                    }
                                                });
                                            });
                                }
                            })

                        }
                        cb(); // задача выполнена успешно
                    })

        },
        /**
         * Проверка на отправку автосообщения 
         */
        checkAutoSendAR2: function (job, cb) {
            sails.log.info('Jobs.checkAutoSendAR2:' + job.id + ' type ' + job.type);
            sails.log('Jobs data.id:' + job.data.id);
            // поиск сообщения в списке 
            var _where = {
                AccountSid: null
                        // id: job.data.id 
                        //TODO: добавитьограничение поиска по группе(комнате)
            };
            Message
                    .find(_where)
                    .limit(1)
                    .sort({createdAt: 'desc'}) // сортировка по дате создания
                    .exec(
                            function (error, msgs) {
                                if (error) {
                                    cb(new Error("Error serach last Message"));
                                } else {
                                    if (msgs.length === 0) {
                                        return cb(null);
                                    }
                                    var msg = msgs[0];
                                    console.log('msg find ->', msg);
                                    sails.log.info("Message id =", msg.id, "  ?  " + job.data.id);
                                    //sails.log.info("Message ", msg.Boby);
                                    if (msg.id === job.data.id) {
                                        Message.create({Body: " AR2"}).exec(function (err, _message) {
                                            if (err) {
                                                cb(new Error("Error create new Message"));
                                            } else {
                                                sails.log.info("Create new Message AR2 ");
                                                console.log(_message);
                                                cb(null);
                                            }
                                        });
                                    } else {

                                    }
                                }
                            }
                    )
        },
        /**
         * Проверка на отправку автосообщения 
         */

        checkAutoSendAR2sms: function (job, cb) {
            sails.log.info('Jobs.checkAutoSendAR2sms:' + job.id + ' type ' + job.type);
            sails.log('Jobs data.id:' + job.data.id);
            // проверка активного диалога 
            Conversations.findOne({id: job.data.dialog, isactive: true}).then(
                    function (err, _dialog) {
                        // поиск сообщения в списке 
                        var _where = {
                            AccountSid: job.data.AccountSid,
                            dialog: job.data.dialog
                        };
                        var _messages = Messages
                                .find(_where)
                                .limit(1)
                                .sort({createdAt: 'desc'}) // сортировка по дате создания
                                .then(
                                        function (_messages) {
                                            return _messages;
                                        }
//                                .exec(
//                                        function (error, msgs) {
//                                            if (error) {
//                                                cb(new Error("Error serach last Messages"));
//                                            } else {
//                                                if (msgs.length === 0) {
//                                                    return cb(null);
//                                                }
//                                                var msg = msgs[0];
//                                                console.log('msg find ->', msg);
//                                                sails.log.info("Messages id =", msg.id, "  ?  " + job.data.id);
//                                                if (msg.id === job.data.id) { 
//                                                    Messages.create({Body: " AR2"}).exec(function (err, _message) {
//                                                        if (err) {
//                                                            cb(new Error("Error create new Message"));
//                                                        } else {
//                                                            sails.log.info("Create new Message AR2 ");
//                                                            console.log(_message);
//                                                            cb(null);
//                                                        }
//                                                    });
//                                                } else {
//                                                    cb(null); // no send again 
//                                                }
//                                            }
//                                        }
                                );
                        // Account Twilio data 
                        var _twlAccount = TwlAccount.findOne({sid: job.data.AccountSid}).then(
                                function (_account) {
                                    return _account;
                                });
                        // Current Phone         
                        var _twlPhoneNumber = TwlPhoneNumber.findOne({accountSid: job.data.AccountSid}).then(
                                function (_phone) {
                                    return _phone;
                                });
 
                        // Current Autorresponse        
                        var _autoresponseSettings = AutoresponseSettings.findOne({AccountSid: job.data.AccountSid}).then(
                                function (_autoresponseSettings) {
                                    return _autoresponseSettings;
                                }
                         );
                        return [_dialog, _messages, _twlAccount, _twlPhoneNumber, _autoresponseSettings]
                    }
            ).spread(
                    function (_dialog, _messages, subAccountData , _twlPhoneNumber, _autoresponseSettings) {
                        console.log("=============", _twlAccount);
                        console.log("=============", _twlPhoneNumber);
                        var msgs = _messages;
                        if (msgs.length === 0) {
                            return cb(null);
                        }
                        var msg = msgs[0];
                        console.log('msg find -> ', msg);
                        sails.log.info("Messages id = ", msg.id, "  ?  " + job.data.id);
                        if (msg.id === job.data.id) {
                            cb(null); // no send again 
//                            _sendParam = {
//                                AccountSid: subAccountData.AccountSid,
//                                authToken: subAccountData.authToken,
//                                from: _twlPhoneNumber.phoneNumber,
//                                to: _params.From,
//                                body: _autoresponseSettings.AR1
//                            };
//                            TwilioService.sendSMS(_sendParam, function (err, autoresponseSMS) {
//                                
//                                
//                            });


                            //                            Messages.create({Body: " AR2"}).exec(function (err, _message) {
                            //                                if (err) {
                            //                                    cb(new Error("Error create new Message"));
                            //                                } else {
                            //                                    sails.log.info("Create new Message AR2 ");
                            //                                    console.log(_message);
                            //                                    cb(null);
                            //                                }
                            //                            });
                        } else {
                            cb(null); // no send again 
                        }
                    }

            ).fail(
                    function (err) {
                        cb(new Error("Error checkAutoSendAR2sms"));
                    }
            );
        },
    }

}