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

    '/': 'PagesController.chatroom',
    '/home': 'PagesController.index',
    '/chatroom': 'PagesController.chatroom',
    /***************************************************************************
     *                                                                          *
     * Custom routes here...                                                    *
     *                                                                          *
     *  If a request to a URL doesn't match any of the custom routes above, it  *
     * is matched against Sails route blueprints. See `config/blueprints.js`    *
     * for configuration options and examples.                                  *
     *                                                                          *
     ***************************************************************************/
    'get /messages/migrate': {
        controller: 'MessagesController',
        action: 'migrate',
        locals: {layout: 'layout'}
    },
    /***
     * API routes
     * 
     */
    /**
     * Operators 
     */
    'get /api/v1/operators': {
        controller: 'OperatorsController',
        action: 'find',
        locals: {layout: 'layout'}
    },
    // calback for send messages
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
    'post /api/v1/messages/client': {
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
    }

};
