/**
 * Development environment settings
 *
 * This file can include shared settings for a development team,
 * such as API keys or remote database passwords.  If you're using
 * a version control solution for your Sails app, this file will
 * be committed to your repository unless you add it to your .gitignore
 * file.  If your repository will be publicly viewable, don't add
 * any private information to this file!
 *
 */

module.exports = {
    /***************************************************************************
     * Set the default database connection for models in the development       *
     * environment (see config/connections.js and config/models.js )           *
     ***************************************************************************/

    // models: {
    //   connection: 'someMongodbServer'
    // }
    madrill: {
        MANDRILL_KEY: 's_aEGIXFZIe4vGonFZoqFA',
        MANDRILL_FROM_NAME: "DEMO CrossLinkMedia",
        MANDRILL_FROM_EMAIL: 'nikolay.gerzhan@gmail.com'
    },
    twilio: {
        TWILIO_ACCOUNT_SID: 'AC220dd9ec0df20b77d7cdd306ee34f43a',
        TWILIO_AUTH_TOKEN: 'f702406810816dab63eb2fe7e5001961',
        TWILIO_NUMBER: '+16505675330',
        StatusCallback: 'http://newspaper-plan.cloudapp.net:3000/api/v1/messages/status'
    }
};
