/**
 * Route Mappings
 * (sails.config.routes)
 *
 * Your routes map URLs to views and controllers.
 *
 * If Sails receives a URL that doesn't match any of the routes below,
 * it will check for matching files (images, scripts, stylesheets, etc.)
 * in your assets directory.  e.g. `http://localhost:1337/images/foo.jpg`
 * might match an image file: `/assets/images/foo.jpg`
 *
 * Finally, if those don't match either, the default 404 handler is triggered.
 * See `api/responses/notFound.js` to adjust your app's 404 logic.
 *
 * Note: Sails doesn't ACTUALLY serve stuff from `assets`-- the default Gruntfile in Sails copies
 * flat files from `assets` to `.tmp/public`.  This allows you to do things like compile LESS or
 * CoffeeScript for the front-end.
 *
 * For more information on configuring custom routes, check out:
 * http://sailsjs.org/#/documentation/concepts/Routes/RouteTargetSyntax.html
 */

module.exports.routes = {
    /***************************************************************************
     *                                                                          *
     * Make the view located at `views/homepage.ejs` (or `views/homepage.jade`, *
     * etc. depending on your default view engine) your home page.              *
     *                                                                          *
     * (Alternatively, remove this and add an `index.html` file in your         *
     * `assets` directory)                                                      *
     *                                                                          *
     ***************************************************************************/

    '/': 'PagesController.index',
    '/home': 'PagesController.index',
    'get /register': 'PagesController.spi',
    'get /login': 'PagesController.spi',
    'get /activate?': 'PagesController.spi',
    'get /reset-password?': 'PagesController.spi',
    'get /reset-verification?': 'PagesController.spi',
    
    'get /account/activate?': 'AuthController.activate',
    
    '/chatroom': 'PagesController.chatroom',
    '/management': 'PagesController.management',
    '/management/operators': 'PagesController.management',
     
    '/management/account/profile': 'PagesController.management',
    '/management/account/:id?': 'PagesController.management',
    /***************************************************************************
     *                                                                          *
     * Custom routes here...                                                    *
     *                                                                          *
     *  If a request to a URL doesn't match any of the custom routes above, it  *
     * is matched against Sails route blueprints. See `config/blueprints.js`    *
     * for configuration options and examples.                                  *
     *                                                                          *
     ***************************************************************************/

    // 'get /login': 'AuthController.login',
    'get /logout': 'AuthController.logout',
    'get /user/create': 'AuthController.register',
    'get /messages/migrate': {
        controller: 'MessagesController',
        action: 'migrate',
        locals: {layout: 'layout'}
    },
    /***
     * API routes
     * 
     */ 
    //  send messages
    'post /api/v1/messages': {
        controller: 'MessagesController',
        action: 'newMessage',
        locals: {layout: 'layout'}
        //TODO: add API keys controll 
    },
    // calback for send messages
    'post /api/v1/messages/status': {
        controller: 'MessagesController',
        action: 'statusMessage',
        locals: {layout: 'layout'}
        //TODO: add API keys controll 
    },
    // messages from client
    'post /api/v1/messages/client/:number': {
        controller: 'MessagesController',
        action: 'clientMessage',
        locals: {layout: 'layout'}
        //TODO: add API keys controll 
    },
    // save fatal error send as messages
    'post /api/v1/messages/client/fallback': {
        controller: 'FallbackMessageController',
        action: 'create',
        locals: {layout: 'layout'}
        //TODO: add API keys controll 
    },
    /***
     * Auth API
     */
    'POST /api/v1/auth/authenticate': 'AuthController.authenticate',
    'POST /api/v1/auth/logout': 'AuthController.logout',
    'POST /api/v1/auth/forgotpassword': 'AuthController.forgotpassword',
    'POST /api/v1/auth/updatepassword': 'AuthController.updatepassword',
    'PUT /api/v1/auth/activate': 'AuthController.updatepassword',
    /**
     * API Conversations
     */
    'POST /api/v1/conversations/:id/operator': 'ConversationsController.setOperator',
    'get /api/v1/conversations': 'ConversationsController.find',
    'get /api/v1/conversations/:id': 'ConversationsController.find',
    /**
     * API Operators
     */
    'get /api/v1/operators':{
        controller: 'OperatorsController',
        action: 'find',
        locals: {layout: 'layout'}
    }, 
    'get /api/v1/operators/:id': 'OperatorsController.find',
    'post /api/v1/operators': 'OperatorsController.create',
    'put /api/v1/operators/:id': 'OperatorsController.update',
    'delete /api/v1/operators/:id': 'OperatorsController.destroy',
    
    //
    'get /api/v1/apikey/:id': 'AuthController.apikey',
    'get /api/v1/account/settings': 'AutoresponseSettingsController.getSettings',
    'put /api/v1/account/settings/:type': 'AutoresponseSettingsController.saveSettings',
    'put /api/v1/account/changepassword': 'AuthController.changePassword',
    'get /api/v1/account/profile/:id':"ProfileController.getProfile",
    'put /api/v1/account/profile/:id':"ProfileController.saveProfile",
};
