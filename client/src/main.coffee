conf = #require './appconfig'
  appName: "demoApp"
angular = require 'angular'
uiRouter = require 'angularUiRouter'  
#auth = require('./auth/index')
#console.log auth
# angular is required globally
myApp = angular.module conf.appName, [
    uiRouter 
    require('./common/index')['name']
  ]#,auth]
  
 
  .run [-> 
	   console.log 'run'
  ] 
  ## 
  # $stateProvider
  ##   
  .config [ '$stateProvider',($stateProvider)->
    

  ]   
  
angular.bootstrap(document.getElementsByTagName('html'), [myApp['name'],
        ->
            console.info('The following is required if you want AngularJS Scenario tests to work');
            #            // The following is required if you want AngularJS Scenario tests to work
            #            //ng.element(document).find('html').addClass('ng-app: ' + app_init['name']);
            #            //document.getElementsByTagName('html').addClass('ng-app');
            #            // return ng;

    ]);
angular.resumeBootstrap(); #//https://docs.angularjs.org/guide/bootstrap & http://stackoverflow.com/questions/25668958/angular-is-missing-resumebootstrap-function

module.exports = myApp