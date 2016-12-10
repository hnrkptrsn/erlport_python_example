%%%-------------------------------------------------------------------
%% @doc erlport_python_example public API
%% @end
%%%-------------------------------------------------------------------

-module(erlport_python_example_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    erlport_python_example_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
