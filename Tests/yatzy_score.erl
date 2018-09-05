%%%-------------------------------------------------------------------
%%% @author euan.mcginness
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Sep 2018 09:32
%%%-------------------------------------------------------------------
-module(yatzy_score).
-author("euan.mcginness").

-include_lib("eunit/include/eunit.hrl").

simple_test() ->
    ?assert(true).

upper_test() ->
    ?assertEqual(2, yatzy_score:upper(1, [1, 3, 2, 1, 4])).

one_pair_test() ->
    ?assertEqual(10, yatzy_score:one_pair([5, 3, 3, 5, 2])).

%% need some negative testing, ie, things that should not give you points
two_pair_test() ->
    ?assertEqual(14, yatzy_score:two_pair([1, 3, 4, 3, 4])).

three_of_a_kind_test() ->
    ?assertEqual(15, yatzy_score:three_of_a_kind([5, 5, 5, 1, 2])).

%% need some tests with things out of order.
four_of_a_kind_test() ->
    ?assertEqual(16, yatzy_score:four_of_a_kind([4, 4, 4, 4, 1])).

%% small is 1,2,3,4,5
small_straight_test() ->
    ?assertEqual(10, yatzy_score:small_straight([1, 2, 3, 4, 3])).

%% large is 2,3,4,5,6
big_straight_test() ->
    ?assertEqual(14, yatzy_score:big_straight([1, 2, 3, 4, 5])).

%% need some negative testing, ie, things that should not give you points
full_house_test() ->
    ?assertEqual(13, yatzy_score:full_house([1, 1, 1, 5, 5])).

chance_test() ->
    ?assertEqual(15, yatzy_score:chance([1, 2, 3, 4, 5])).

yatzy_test() ->
    ?assertEqual(50, yatzy_score:yatzy([5, 5, 5, 5, 5])).



