%%%------------th-------------------------------------------------------
%%% @author euan.mcginness
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Sep 2018 11:25
%%%-------------------------------------------------------------------
-module(yatzy_score).
-author("euan.mcginness").
-define(uppers, [ones, twos, threes, fours, fives, sixes]).
-define(allFields, [ones, twos, threes, fours, fives, sixes, sum_of_uppers, bonus_points, one_pair, two_pair,
    three_of_a_kind, four_of_a_kind, small_straight, large_straight, full_house, chance, yatzy]).

%% API
-export([upper/2, one_pair/1, two_pair/1, three_of_a_kind/1, four_of_a_kind/1, small_straight/1,
    big_straight/1, full_house/1, chance/1, yatzy/1, calculate_uppers/1, grand_total/1]).

%% Tried a few different methods of scoring just to see what happens.

-spec upper(integer(), list()) -> integer().
upper(IntOfChoice, ListOfRoll) ->
    count(IntOfChoice, ListOfRoll, 0).

-spec one_pair(list()) -> integer().
%% need more or a pattern matching approach
%% one_pair(List) ->
%%     case lists:sort(List) of
%%         [_,_,_,X,X] -> 
%%             2 * X;
%%         [_,_,X,X,_] ->
%%             2 * X;
%%             ... and so on
%% This goes for all solutions.
one_pair(List) ->
    List1 = get_your_list(2, List),
    lists:max(List1) * count(lists:max(List1), List, 0).

-spec two_pair(list()) -> integer().
two_pair(List) ->
    sum_list(get_your_list(2, List)).

-spec three_of_a_kind(list()) -> integer().
three_of_a_kind(List) ->
    sum_list(get_your_list(3, List)).

-spec four_of_a_kind(list()) -> integer().
four_of_a_kind(List) ->
    sum_list(get_your_list(4, List)).

-spec small_straight(list()) -> integer().
small_straight([1, 2, 3, 4, _]) ->
    10.

-spec big_straight(list()) -> integer().
big_straight([_, 2, 3, 4, 5]) ->
    14.

%% Yes!! More patterns like this!   
-spec full_house(list()) -> integer().
full_house([X, X, X, Y, Y]) ->
    (X * 3) + (Y * 2).

-spec chance(list()) -> integer().
chance(List) ->
    sum_list(List).

-spec yatzy(list()) -> integer().
yatzy([X, X, X, X, X]) ->
    50.

-spec calculate_uppers(map()) -> integer().
calculate_uppers(Map) ->
    Uppers = [maps:get(X, Map) || X <- ?uppers],
    UppersInt = sum_list(Uppers),
    NewMap = case UppersInt >= 63 of
                 true ->
                     maps:put(sum_of_uppers, UppersInt, Map),
                     maps:put(bonus_points, 50, Map);
                 false ->
                     maps:put(sum_of_uppers, UppersInt, Map)
             end,
    NewMap.

-spec grand_total(map()) -> integer().
grand_total(Map) ->
    AllValues = [maps:get(X, Map) || X <- ?allFields],
    AllInt = sum_list(AllValues),
    maps:put(grand_total, AllInt, Map).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Helper Functions
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

sum_list(List) ->
    sum_list(List, 0).

-spec sum_list(list(), integer()) -> integer().
sum_list([], Count) ->
    Count;
sum_list([Hd | List], Count) ->
    case is_atom(Hd) of
        true ->
            sum_list(List, 0 + Count);
        false ->
            sum_list(List, Hd + Count)
    end.

get_your_list(Int, List) ->
    lists:filtermap(
        fun(X) ->
            count(X, List, 0) == Int end,
        List
    ).

-spec print_list(list()) -> atom().
print_list([]) ->
    ok;
print_list([Hd | List]) ->
    io:format("~p ~n", [Hd]),
    print_list(List).








