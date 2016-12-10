%%%-------------------------------------------------------------------
%%% @author henrikgudbrandpetersen
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Dec 2016 21:51
%%%-------------------------------------------------------------------
-module(pysimple).
-author("henrikgudbrandpetersen").

%% API
-export([test/0]).
-export([simple_sqrt/1, simple_add/2]).
-export([main/0, show_list/2]).

test() ->
  42.

simple_sqrt(A) ->
  % Make Python library calls
  {ok, Pid} = python:start(),

  Result = python:call(Pid, math, sqrt, [A]),

  {ok, Result}.

simple_add(A, B) ->
  % A bit wasteful to start and stop a process like this but you could
  {ok, Pid} = python:start(),

  Result = python:call(Pid, operator, add, [A,B]),

  python:stop(Pid),

  lager:info("Result from python ~p~n", [Result]),

  {ok, Result}.


main() ->
  {ok, Pid} = python:start(),
  {ok, Result} = python:call(Pid, 'py_math_01', main, []),
  show_list(Result, 1),
  ok.

show_list([], _) -> ok;
show_list([Item|Items], Count) ->
  io:format("~p. Item: ~p~n", [Count, Item]),
  show_list(Items, Count + 1).
