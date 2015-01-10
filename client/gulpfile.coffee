## gulp plugins 
gulp = require 'gulp'
gutil = require 'gulp-util'

## misc 
argv = require("minimist")(process.argv.slice(2));

## webpak 
webpack = require 'webpack'
WebpackDevServer = require 'webpack-dev-server'
webpackConfig = require './webpack.config.coffee'

ngAnnotatePlugin = require('ng-annotate-webpack-plugin');

## 
if (argv.production)  ## --production option
  webpackConfig.plugins = webpackConfig.plugins.concat(new ngAnnotatePlugin(add: true), new webpack.optimize.UglifyJsPlugin())
  webpackConfig.devtool = false;
  webpackConfig.debug = false
 
_devPort = 3000
_depHost = 'localhost'

# Default task
gulp.task 'default', ['webpack-dev-server'], ->
    console.log '==', process.cwd()
###
# Ddevelopment build
###
gulp.task 'webpack-dev-server', (cb) ->
    # modify some webpack configuration options
    conf = Object.create webpackConfig
    
    conf.devtool = 'source-map'
    # or conf.devtool = "eval"
    conf.debug = true
    # Start a webpack-dev-server
    new WebpackDevServer webpack(conf),
        contentBase: conf.contentBase
        #or: contentBase: "http://localhost/"
        publicPath: "/" + conf.output.publicPath
        stats:
            colors: true
    .listen _devPort, _depHost , (err) ->
        throw new gutil.PluginError('webpack-dev-server',err) if err
        gutil.log '[webpack-dev-server]',"http://#{_depHost}:#{_devPort}/webpack-dev-server/index.html"