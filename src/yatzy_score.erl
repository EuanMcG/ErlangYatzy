%%%-------------------------------------------------------------------
%%% @author euan.mcginness
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Sep 2018 11:25
%%%-------------------------------------------------------------------
-module(yatzy_score).
-author("euan.mcginness").

%% API
-export([upper/2, three_of_a_kind/1, one_pair/1, print_list/1]).

-spec upper(integer(), list()) -> integer().
upper(IntOfChoice, ListOfRoll) ->
  count(IntOfChoice, ListOfRoll, 0).

-spec three_of_a_kind(list()) -> integer().
three_of_a_kind(List) ->
  sum_list([X || X <- List, count(X, List, 0) == 3], 0).

-spec one_pair(list()) -> integer().
one_pair(List) ->
  List1 = lists:filtermap(
    fun(X) ->
      count(X, List, 0) == 2 end,
    List
  ),
  lists:max(List1) * count(lists:max(List1), List, 0).

-spec count(integer() | _, list(), integer()) -> integer().
count(_Int, [], Count) ->
  Count;
count(Int, [Head | RList], Count) ->
  case Int == Head of
    false ->
      count(Int, RList, 0 + Count);
    true ->
      count(Int, RList, 1 + Count)
  end.

-spec sum_list(list(), integer()) -> integer().
sum_list([], Count) ->
  Count;
sum_list([Hd | List], Count) ->
  sum_list(List, Hd + Count).

-spec print_list(list()) -> atom().
print_list([]) ->
  ok;
print_list([Hd | List]) ->
  io:format("~p ~n", [Hd]),
  print_list(List).








