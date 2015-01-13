angular = require 'angular'  
ngModule = angular.module 'common', [
		require 'angularUiRouter'
	]
	.run [ ->
		console.log 'run common'
	]
## 	
module.exports = ngModule