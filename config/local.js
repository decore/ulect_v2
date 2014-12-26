/**
 * Local environment settings
 *
 * Use this file to specify configuration settings for use while developing
 * the app on your personal system: for example, this would be a good place
 * to store database or email passwords that apply only to you, and shouldn't
 * be shared with others in your organization.
 *
 * These settings take precedence over all other config files, including those
 * in the env/ subfolder.
 *
 * PLEASE NOTE:
 *		local.js is included in your .gitignore, so if you're using git
 *		as a version control solution for your Sails app, keep in mind that
 *		this file won't be committed to your repository!
 *
 *		Good news is, that means you can specify configuration for your local
 *		machine in this file without inadvertently committing personal information
 *		(like database passwords) to the repo.  Plus, this prevents other members
 *		of your team from commiting their local configuration changes on top of yours.
 *
 *    In a production environment, you probably want to leave this file out
 *    entirely and leave all your settings in env/production.js
 *
 *
 * For more information, check out:
 * http://sailsjs.org/#/documentation/reference/sails.config/sails.config.local.html
 */

module.exports = {
    /***************************************************************************
     * Your SSL certificate and key, if you want to be able to serve HTTP      *
     * responses over https:// and/or use websockets over the wss:// protocol  *
     * (recommended for HTTP, strongly encouraged for WebSockets)              *
     *                                                                         *
     * In this example, we'll assume you created a folder in your project,     *
     * `config/ssl` and dumped your certificate/key files there:               *
     ***************************************************************************/

    // ssl: {
    //   ca: require('fs').readFileSync(__dirname + './ssl/my_apps_ssl_gd_bundle.crt'),
    //   key: require('fs').readFileSync(__dirname + './ssl/my_apps_ssl.key'),
    //   cert: require('fs').readFileSync(__dirname + './ssl/my_apps_ssl.crt')
    // },

    /***************************************************************************
     * The `port` setting determines which TCP port your app will be           *
     * deployed on.                                                            *
     *                                                                         *
     * Ports are a transport-layer concept designed to allow many different    *
     * networking applications run at the same time on a single computer.      *
     * More about ports:                                                       *
     * http://en.wikipedia.org/wiki/Port_(computer_networking)                 *
     *                                                                         *
     * By default, if it's set, Sails uses the `PORT` environment variable.    *
     * Otherwise it falls back to port 1337.                                   *
     *                                                                         *
     * In env/production.js, you'll probably want to change this setting       *
     * to 80 (http://) or 443 (https://) if you have an SSL certificate        *
     ***************************************************************************/

    // port: process.env.PORT || 1337,

    /***************************************************************************
     * The runtime "environment" of your Sails app is either typically         *
     * 'development' or 'production'.                                          *
     *                                                                         *
     * In development, your Sails app will go out of its way to help you       *
     * (for instance you will receive more descriptive error and               *
     * debugging output)                                                       *
     *                                                                         *
     * In production, Sails configures itself (and its dependencies) to        *
     * optimize performance. You should always put your app in production mode *
     * before you deploy it to a server.  This helps ensure that your Sails    *
     * app remains stable, performant, and scalable.                           *
     *                                                                         *
     * By default, Sails sets its environment using the `NODE_ENV` environment *
     * variable.  If NODE_ENV is not set, Sails will run in the                *
     * 'development' environment.                                              *
     ***************************************************************************/

    environment: process.env.NODE_ENV || 'development',
//    twilio: {
//        TWILIO_ACCOUNT_SID: 'AC220dd9ec0df20b77d7cdd306ee34f43a',
//        TWILIO_AUTH_TOKEN: 'f702406810816dab63eb2fe7e5001961',
//        TWILIO_NUMBER: '+16505675330',
//        StatusCallback: 'http://78921f6d.ngrok.com/api/v1/messages/status'
//    }
    //    madrill: {
    //        MANDRILL_KEY: 'qr94w8FY5Nk4jUrTYcAP9g',
    //        MANDRILL_FROM_NAME: "CrossLinkMedia",
    //        MANDRILL_FROM_EMAIL: 'nikolay.gerzhan@gmail.com'
    //    }
    //    ,
    //    // Master Account web application
    //    twilio: {
    //        TWILIO_ACCOUNT_SID: 'ACc0d344677835c0a303c92d59cfa1b9d8',
    //        TWILIO_AUTH_TOKEN: 'e6dc7e7cceed05eedf5e644975cab642',
    //        TWILIO_NUMBER: '+18303550804',
    //        StatusCallback: 'http://newspaper-plan.cloudapp.net:3000/api/v1/messages/status'
    //    }
       // Master Account web application
//    twilio: {
//        TWILIO_ACCOUNT_SID: 'ACf05f511ddc69d343935861aedb799742',
//        TWILIO_AUTH_TOKEN: '9df8a9b345ded148b21f48e9852ef37e',
//        TWILIO_NUMBER: "+15005550006",//'+18303550804',
//        StatusCallback: 'http://78921f6d.ngrok.com/api/v1/messages/status'
//    } 
};
