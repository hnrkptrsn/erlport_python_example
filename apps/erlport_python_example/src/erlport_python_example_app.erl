%%%-------------------------------------------------------------------
%% @doc erlport_python_example public API
%% @end
%%%-------------------------------------------------------------------

-module(erlport_python_example_app).

-behaviour(application).
-behaviour(supervisor).

%% Application callbacks
-export([start/2, stop/1]).
-export([init/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    %%
    %% Start the cowboy handler for new sessions
    %%
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/fortune", fortune_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(http, 100, [{port, 8080}], #{
        env => #{dispatch => Dispatch}
    }),

    supervisor:start_link({local, erlport_python_example_sup}, ?MODULE, []).
    %erlport_python_example_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================

init([]) ->
    % Grab the list of pools from app.src
    {ok, Pools} = application:get_env(erlport_python_example, pools),

    lager:info("Pools ~p~n", [Pools]),

    % Create a poolspec by mapping this function on the list (we have one here so overkill)
    PoolSpecs = lists:map(
        fun({Name, SizeArgs, WorkerArgs}) ->
            PoolArgs =
                [{name, {local, Name}},{worker_module, pyworker}] ++ SizeArgs,

            poolboy:child_spec(Name, PoolArgs, WorkerArgs)  % Now hand the spec to poolboy for setup
        end, Pools),

    lager:info("After pool specs ~p~n", [PoolSpecs]),

    {ok, {{one_for_one, 10, 10}, PoolSpecs}}.


