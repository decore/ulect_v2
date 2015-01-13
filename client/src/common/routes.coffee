ngModule = require './module'
console.log ngModule
## set HTML5 mode
ngModule.config ['$locationProvider', ($locationProvider)->
		## 
		$locationProvider.html5Mode(
		    enabled: true
		    requireBase: true
		).hashPrefix('#')
]   
## config anonim state
.config [ '$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider)->
	$urlRouterProvider.when('/','/home')
		.otherwise('/')
	$stateProvider.state 'anon',
		abstract: true
		url: '^/'
		views:
			"@":
            	template: '<h2> content</h2>'	
			"header": 
				template: '<h1>!!!</h1>'  
	$stateProvider.state 'anon.home', 
		url: '^/home'	
]
.config [ '$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider)->
	$stateProvider.state 'user',
		abstract: true
		url: '^/user'	
]


module.exports = ngModule