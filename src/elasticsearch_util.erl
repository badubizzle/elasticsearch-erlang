%%%-------------------------------------------------------------------
%%% @author badu
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Apr 2015 8:12 PM
%%%-------------------------------------------------------------------
-module(elasticsearch_util).
-author("badu").
-include("elasticsearch.hrl").

%% API
-export([update_script/1, match/3, match/2, term/2]).

%% @doc generate elasticsearch update js script.
-spec update_script(list()) -> binary().
update_script(L)->
  update_script(L, <<"">>).
update_script([], Bin)->
  Bin;
update_script([{K, V}|Rest], Bin)->
  Part=re:replace(
    re:replace(<<"ctx._source.{key}='{val}';">>, <<"{key}">>,
      K, [global, {return, binary}]), <<"{val}">>,V, [global, {return, binary}]),
  update_script(Rest, <<Bin/binary, Part/binary>>).


%% @doc generate match query for a field.
-spec match(binary(), any(), number()) -> list().
match(Field, Value, Boost)->
  [{?MATCH, [{Field,[{?QUERY, Value}, {?BOOST, Boost}]}]}].
match(Field, Value)->
  [{?MATCH, [{Field, Value}]}].

term(Field, Value)->
  [{?TERM, [{Field, Value}]}].