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
