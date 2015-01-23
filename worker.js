var sails = require('sails'),
        Job = require('kue').Job;

/**
 * Lift sails without starting the server
 * 
 * Setting worker to true will execute the global
 * startWorker callback instead of the default sails 
 * bootstrap callback function.
 *
 * This will prevent Sails from starting the server.
 * We are also setting a very long bootstrap timeout (1 year)
 * so that Sails won't warn us about an unusually long 
 * bootstrapping time.
 */

sails.lift({
    worker: true,
    bootstrapTimeout: 60 * 60 * 24 * 365
});


/**
 * Log job success and failures
 */

var logJobs = function () {
    Jobs
            .on('job complete', function (id) {
                Job.get(id, function (err, job) {
                    if (err)
                        return;
                    sails.log.info('Job \'' + job.type + '\' (ID: ' + id + ') completed successfully.');
                    //https://github.com/learnboost/kue#queue-events
                    job.remove(function (err) {
                        if (err)
                            throw err;
                        sails.log.warn('removed completed job #%d', job.id);
                    });
                });
            })
            .on('job failed', function (id) {
                Job.get(id, function (err, job) {
                    if (err)
                        return;
                    sails.log.warn('Job \'' + job.type + '\' (ID: ' + id + ') failed. Error: ' + job._error);
                });
            });
}


/**
 * Start job processors by invoking
 * Jobs.process() on each one of them
 */

var startProcessors = function () {
    for (var identity in Jobs._processors) {
        Jobs.process(identity, Jobs._processors[identity]);
    }
}


/**
 * Global startWorker callback that will kick off the worker instance
 *
 * This must be executed from within bootstrap.js if
 * sails.config.worker is set to true
 */

global.startWorker = function () {

    logJobs();
    startProcessors();

    //sails.log.ship();
//          setInterval(
//                function () {
//                     Jobs.promote(); 
//                },1000);
    //    setInterval(
    //            function () {
    //                console.log('start ');
    //                var job = Jobs.create("sendAR2", {now: new Date()}, function () {
    //                    sails.log.info('cb ');
    //                }).save(function (err, data) {
    //                    console.log(err, data);
    //                    Jobs.create("sendSMS", {}).save();
    //                    _.forEach(data, function (item) {
    //                        
    //                    });
    //                });
    //            }
    //    , 3000);
    var log = sails.log;
    log.info('Sails worker instance started');
    log.info('To shut down Sails worker, press <CTRL> + C at any time.');
    console.log();
    log('--------------------------------------------------------');
    log(':: ' + new Date());
    log();
    log('Environment\t: ' + sails.config.environment);

}