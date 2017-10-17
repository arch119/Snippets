var watch = require('node-watch');
var exec = require('child_process').exec;
var child;

watch('.', { 
	recursive: true,
	filter: function(name){
		 return !/.git\//.test(name);
			} 
	}, function(evt, name) {
  console.log('%s changed.', name);

  // executes `pwd`
	child = exec(". ~/.bashrc && echo edit fs_watch.js to specify a command to run", { "shell": "/bin/bash"}, function (error, stdout, stderr) {
	  console.log(stdout);
	  if(error != null){
	  	console.log(error);
	  }
	});

});
