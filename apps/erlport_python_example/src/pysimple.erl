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
-export([simple_sqrt/1, simple_add/2, version/0]).
-export([example/0, fortune/0]).

test() ->
  42.

simple_sqrt(A) ->
  % Make Python library calls
  {ok, Pid} = python:start([{python, "python3"}]), % python:start() gives you the default

  Result = python:call(Pid, math, sqrt, [A]),

  {ok, Result}.

simple_add(0, B) -> {ok, B};
simple_add(A, 0) -> {ok, A};
simple_add(A, B) ->
  % A bit wasteful to start and stop a process like this but you could
  {ok, Pid} = python:start([{python, "python3"}]),

  Result = python:call(Pid, operator, add, [A,B]),

  python:stop(Pid),

  lager:info("Result from python ~p~n", [Result]),

  {ok, Result}.

version() ->
  {ok, Pid} = python:start([{python, "python3"}]),

  Result = python:call(Pid, sys, 'version.__str__', []),

  python:stop(Pid),

  lager:info("Result from python ~p~n", [Result]),

  {ok, Result}.

example() ->
  {ok, Pid} = python:start([{python, "python3"}]),

  Result = python:call(Pid, test, example, []),

  python:stop(Pid),

  lager:info("Result from python ~p~n", [Result]),

  {ok, Result}.

fortune() ->
  {ok, Pid} = python:start([{python, "python3"}]),

  Result = python:call(Pid, test, myfortune, []),

  python:stop(Pid),

  UniBin = unicode:characters_to_binary(Result),

  lager:info("Result from python ~p~n", [UniBin]),

  {ok, UniBin}.

