/**
 * Bootstrap
 * (sails.config.bootstrap)
 *
 * An asynchronous bootstrap function that runs before your Sails app gets lifted.
 * This gives you an opportunity to set up your data model, run jobs, or perform some special logic.
 *
 * For more information on bootstrapping your app, check out:
 * http://sailsjs.org/#/documentation/reference/sails.config/sails.config.bootstrap.html
 */
//https://github.com/ragulka/sails-starter-app/blob/master/config/bootstrap.js
var async = require('async');

module.exports.bootstrap = function (cb) {
    // It's very important to trigger this callback method when you are finished
    // with the bootstrap!  (otherwise your server will never lift, since it's waiting on the bootstrap)
    /**
     * Expose the local URL of our app
     */

    // Check if app runs on SSL
    sails.config.usingSSL = (
            (
                    sails.config.serverOptions &&
                    sails.config.serverOptions.key &&
                    sails.config.serverOptions.cert
                    ) || (
            sails.config.express &&
            sails.config.express.serverOptions &&
            sails.config.express.serverOptions.key &&
            sails.config.express.serverOptions.cert
            )
            );
    // Compose the local app url
    sails.config.localAppURL = ( sails.config.usingSSL ? 'https' : 'http' ) + '://' + sails.config.host + ':' + sails.config.port + '';
    console.log(sails.config.localAppURL);
    //////////////////////
    // Async bootstrapping
    //////////////////////

    async.series([
        /**
         * Setup Kue
         */

        function (cb) {
            var kue = require('kue'),
                    redis = require('../node_modules/kue/node_modules/redis');

            // Override default createClient function to allow
            // config options for redis client
            kue.redis.createClient = function () {
                var options = sails.config.redis;

                // Extract options from Redis URL
                if (sails.config.redis.url) {
                    var redisUri = url.parse(sails.config.redis.url);
                    options = {
                        host: redisUri.hostname,
                        port: redisUri.port,
                        pass: redisUri.auth.split(':')[1]
                    };
                }

                var client = redis.createClient(options.port, options.host, options);

                // Log client errors
                client.on("error", function (err) {
                    sails.log.error(err);
                });

                // Authenticate, if required
                if (options.pass) {
                    client.auth(options.pass, function (err) {
                        if (err)
                            sails.log.error(err);
                    });
                }

                return client;
            }
//
            // Create job queue on Jobs service
            var processors = Jobs._processors;
            Jobs = kue.createQueue();
            Jobs._processors = processors;
            console.log('===============================');
            cb();
        }

    ], function () {
        ////////////////////////////////
        // All bootstrapping is finished
        ////////////////////////////////

        // If this is a worker instance, execute startWorker
        // callback to skip starting the server
        if (sails.config.worker) {
                console.log('===StartWorker');
            return startWorker();
        }

        // If this is a normal Sails instance,
        // execute the callback to start the server
        cb();
    });

};
