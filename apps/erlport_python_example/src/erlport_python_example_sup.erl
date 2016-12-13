%%%-------------------------------------------------------------------
%% @doc erlport_python_example top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(erlport_python_example_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
	% 
	% one_for_one == If a child process terminates, only that process is restarted.
	% If more than MaxR==10 number of restarts occur in the last MaxT==10 seconds, 
	% the supervisor terminates all the child processes and then itself.
	% 
	% NOTE that MaxR and MaxT should be a lot bigger for a production setup. :)
	%
    {ok, { {one_for_one, 10, 10}, []} }.

%%====================================================================
%% Internal functions
%%====================================================================
