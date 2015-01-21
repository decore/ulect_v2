///* 
// http://blog.thesparktree.com/post/92465942639/ducktyping-sailsjs-core-for-background-tasks-via
// */
//
//var kue = require('kue')
//    , kue_engine  = kue.createQueue(
//    {
//        prefix: 'kue',
////        redis: {
////            port: ..,
////            host: ..,
////            auth: ..
////        }
//    });
//
//kue_engine.process("MyBackgroundTaskName",function (job, done) {
//    User.findOne(job.data.user_id)
//        .then(function (user) {
//            return user.long_running_background_task()
//        })
//        .then(function (processed) {
//            console.log("finished job!");
//            console.log(processed);
//            done();
//        })
//        .fail(function (err) {
//            console.log("error in job!");
//            console.log(err);
//            done(err);
//        })
//        .done();
//})
//
//
//process.once('SIGTERM', function (sig) {
//    kue_engine.shutdown(function (err) {
//        console.log('Kue is shut down.', err || '');
//        process.exit(0);
//    }, 5000);
//});
//// module.exports.jobs = jobs;
///**
// * 
// */
//module.exports = {
//  jobs : kue_engine ,
//  kue: kue_engine ,
//  redis: {
//    // host      : 'localhost',
//    port      : process.env.NODE_ENV === 'test' ? 6380 : null,
//    // pass:     : '...',
//    url      : process.env.NODE_ENV === 'production' ? process.env.REDIS_URL : null
//  }
//  }

module.exports = {
  redis: {
    host      : 'localhost',
    port      : process.env.NODE_ENV === 'test' ? 6380 : null,
    // pass:     : '...',
    url       : process.env.NODE_ENV === 'production' ? process.env.REDIS_URL : null
  }
}