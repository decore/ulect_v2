path = require 'path'
webpack = require 'webpack'

srcPath =  path.join(__dirname,'src')
distPath = path.join(__dirname,'./../assets/public')
vendorsRoot = path.join(__dirname,'bower_components')

#publicURL = "ht"
module.exports = {
    # webpack-dev-server options used in gulpfile
    # https://github.com/webpack/webpack-dev-server
    contentBase: srcPath# "#{__dirname}/src/"  #TODO:delete "#{srcPath}" #./public"
    ## or: contentBase:  "http://localhost:1337/"#"http://localhost/",
    cache: true
    # The entry point
    entry:
        auth:   "#{srcPath}/auth/index.coffee"
        bundle:  "#{srcPath}/main.coffee"

    output:
        path:  "#{distPath}/"
        publicPath: "http://localhost:1337/"#'public/' ##
        filename: "[name].js"
        chunkFilename: "[id].bundle.js"
        sourceMapFilename: '[file].map'

    module:
        loaders:[
            test: /\.coffee$/
            loader: 'coffee'
        ,
            test: /[\/\\]angular\.js$/
            loader: "exports?angular"
        ,
            test: /\.json$/
            loader: 'json'

        ]
    # don't parse some dependencies to speed up build.
    # can probably do this non-AMD/CommonJS deps
    noParse: [
        path.join vendorsRoot, '/angular'
        path.join vendorsRoot, '/angular-route'
        path.join vendorsRoot, '/angular-ui-router'
        path.join vendorsRoot, '/angular-mocks'
        path.join vendorsRoot, '/jquery'
    ]
    resolve:
        alias:
            bower: vendorsRoot
            angular: 'angular/angular'
            angularUiRouter: 'angular-ui-router/release/angular-ui-router'
            angularCookies: 'angular-cookies/angular-cookies',
            angularResource: 'angular-resource/angular-resource'
        extensions: [
            ''
            '.js'
            '.coffee'
            '.scss'
            '.css'
            '.json'
        ]
        modulesDirectories: [
            'client'
            'lib'
            'bower_components'
            'node_modules'
        ]
        root: [process.cwd(),srcPath]
    plugins: [
            new webpack.ResolverPlugin([
                new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin("bower.json", ["main"])
            ],["normal", "loader"])
        #new webpack.ProvidePlugin
        #    'angular': 'exports?window.angular!bower/angular'
        #new webpack.ProvidePlugin
        #    'angular-ui-router': 'exports?window.angular-ui-router!bower/angular-ui-router'
        #    new webpack.CommonsChunkPlugin("init.js")
    ]

}