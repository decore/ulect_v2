/**
 * UserController
 *
 * @description :: Server-side logic for managing users
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */
//var Puid = require('puid');//https://github.com/pid/puid
module.exports = {
//  // Doing a DELETE /user/:parentid/message/:id will not delete the message itself
//  // We do that here.
//	remove: function(req, res) {
//    var relation = req.options.alias;
//    switch (relation) {
//      case 'messages':
//        destroyMessage(req, res);
//    }
//  },

  create: function(req, res) {
    res.json(301, 'To create a user go to /auth/register');
  },
  
   
          
            
//  resetpass: function(req, res){
//    puid = new Puid(true);
//
//    var email = req.param('email'),
//        newPass = 'demo123456'//puid.generate();
//
//    User.findOneByEmail(email, function( err, user ){
//      console.log(user);
//      console.log(newPass);
//      crypto.generate({saltComplexity: 10}, newPass, function(err, hash){
//        if(err){
//          return cb(err);
//        }else{
//          var emailTemplate = res.render('email/reset.ejs', function(err){
//
//          nodemailer.send({
//            name:       user.firstName + ' ' + user.lastName,
//            from:       sails.config.nodemailer.from,
//            to:         email,
//            subject:    'Peices pass Reset',
//            messageHtml: 'Your new password for ' + newPass
//          }, function(err, response){
//            sails.log.debug('nodemailer sent', err, response);
//          });
//          res.redirect('/login');
//
//        });
//        console.log(user.firstName + user.lastName);
//        console.log(user.email);
//        console.log('original user pass '+ user.password);
//          newPass = hash;
//        console.log('hashed pass: '+ newPass);
//        // console.log(hash);
//          User.update(
//            {password: user.password}, {password: newPass}
//          ).exec(function updateCB(err,updated){
//            console.log('Updated user to have pass ' + newPass);
//          });
//          }
//        });
//      });
//    }
  
  
};

function destroyMessage(req, res) {
  Message.findOne(req.param('id')).exec(function(err, message) {
    if (err) return res.json(err.status, {err: err});
    if (!message) return res.json(404, {err: 'Message not found'});
    if (req.param('parentid') != message.user) return res.json(404, {err: 'Message not found'});

    Message.destroy(req.param('id')).exec(function(err, message) {
      if (err) return res.json(err.status, {err: err});
      return res.json(204, '');
    });
  });


}

