erlport_python_example
=====

Install Erlport following the guide on http://erlport.org/downloads/#installation.
Basically run the following and unzip the release binary into the directory.

	erl
	1> code:lib_dir().
	
It is a requirement that you have Python3 installed for this example, but it will work easily with Python2 with minor changes.
	
Build
-----

    $ ./setup.sh

Check that we have loaded everything ok.

	1> pysimple:example().
	{ok,0.3858515795795573}
	23:53:06.975 [info] Result from python 0.3858515795795573
	
	2> pysimple:fortune().
	It could be worse, you could be in Cleveland.
	{ok,<<"It could be worse, you could be in Cleveland.">>}

open in a browser and point it at http://localhost:8080/fortune

Run
---

Running outside the setup.sh shell script.

	source priv/erlpy3env/bin/activate
	rebar3 shell

Test
----
	
Just a plain python3 call to get the version.

		> pysimple:version().

Actually call the script we have installed locally.

		> pysimple:example().
		> pysimple:fortune().

Explanation 
-----------

For correct unicode display in the terminal this was added to config/vm.args

	+pc latin1

rebar.config

	Added poolboy for the multiprocess setup with Python and lager for logging.
	Rebar3 is flexible as to how you specify dependencies (deps).
	
priv/python

	Very very simple setup, just calling some modules, needs the virtual environment setup correctly though.
	See setup.sh
	
apps/erlport_python_example

	Our test app, simply 
		rebar3 new release erlport_python_example
		
apps/src/erlport_python_example.app.src

	Poolboy configuration parameters are defined here and used in erlport_python_example_app.erl
	You can specify multiple pools, give each a different name and some size arguments as well as
	some other parameters for e.g. connectivity.
	
	{env,[
	   {pools, [
	    % Pool 1
	    {pypool, % Name
	     [{size, 10}, {max_overflow, 20}], % SizeArgs
	     [ % WorkerArgs e.g. db setup or other stuff for the workers
	      {hostname, "127.0.0.1"},
	      {database, "db1"},
	      {username, "db1"},
	      {password, "abc123"}]
	    }
	   ]}
	  ]},
  
apps/src/erlport_python_example_app.erl

	start, sets up cowboy which we use for showing fortunes. (demoability)
	init, reads the arguments and sets up the pool with poolboy.
	call_python, wraps a gen_server call in a poolboy transaction. (check-out, call, check-in)

apps/src/fortune_handler.erl

	Simples cowboy setup, calls the Python process, formats the answer and returns it to the client.
	And the call to the Python is via 
	
		erlport_python_example_app:call_python(pypool, [])
	
	Specify the pool name and any parameters.
	
apps/src/pyworker.erl

	Simple gen_server with a Python state object.
	
	init, start by starting the Python process during init.
	
	handle_call, the 'meat' of the gen_server in this case, get your python pid from the state
		and call your functions, return some interesting result.
	
apps/src/pysimple.erl

	The pattern is start a Python process, make a call using the process id, stop it after use.

	{ok, Pid} = python:start([{python, "python3"}]),
	Result = python:call(Pid, sys, 'version.__str__', []),
	python:stop(Pid),
  

