var path = require('path');
module.exports ={
	entry:[
	'node_modules/webpack-dev-server/bin/webpack-dev-server.js',
		'./DOCXJSonOneFile/docx.js'

	],
	output:{
		path: __dirname,
		filrname:"bundle.js"
	}
}