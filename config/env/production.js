/**
 * Production environment settings
 *
 * This file can include shared settings for a production environment,
 * such as API keys or remote database passwords.  If you're using
 * a version control solution for your Sails app, this file will
 * be committed to your repository unless you add it to your .gitignore
 * file.  If your repository will be publicly viewable, don't add
 * any private information to this file!
 *
 */

module.exports = {
    /***************************************************************************
     * Set the default database connection for models in the production        *
     * environment (see config/connections.js and config/models.js )           *
     ***************************************************************************/

    // models: {
    //   connection: 'someMysqlServer'
    // },

    /***************************************************************************
     * Set the port in the production environment to 80                        *
     ***************************************************************************/

    // port: 80,

    /***************************************************************************
     * Set the log level in production environment to "silent"                 *
     ***************************************************************************/

    // log: {
    //   level: "silent"
    // }
    madrill: {
        MANDRILL_KEY: 'qr94w8FY5Nk4jUrTYcAP9g',
        MANDRILL_FROM_NAME: "CrossLinkMedia",
        MANDRILL_FROM_EMAIL: 'nikolay.gerzhan@gmail.com'
    }
    ,
    // Master Account web application
    twilio: {
        TWILIO_ACCOUNT_SID: 'ACc0d344677835c0a303c92d59cfa1b9d8',
        TWILIO_AUTH_TOKEN: 'e6dc7e7cceed05eedf5e644975cab642',
        TWILIO_NUMBER: '+18303550804',
        StatusCallback: 'http://newspaper-plan.cloudapp.net:3000/api/v1/messages/status'
    }
};
