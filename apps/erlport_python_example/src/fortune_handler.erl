%%%-------------------------------------------------------------------
%%% @author henrikgudbrandpetersen
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Dec 2016 00:24
%%%-------------------------------------------------------------------
-module(fortune_handler).
-author("henrikgudbrandpetersen").

%% API
-export([init/2]).

init(Req0, State) ->
  %Method = cowboy_req:method(Req0),

  {ok, Fortune} = pyworker:fortune(),

  AlteredFortune = binary_to_list(<<"Fortune:\n\n">>) ++ binary_to_list(Fortune),

  Req = cowboy_req:reply(200, #{
    <<"content-type">> => <<"text/plain; charset=utf-8">>
  }, AlteredFortune, Req0),

  {ok, Req, State}. % Try commenting out this line to let it crash but still kind of work

