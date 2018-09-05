%%%-------------------------------------------------------------------
%%% @author euan.mcginness
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Sep 2018 13:01
%%%-------------------------------------------------------------------
-module(yatzy_sheet).
-author("euan.mcginness").

-type sheet() :: #{atom() => integer()}.
-type empty() :: empty.

%% API
-export([new/0, fill/3]).

%%
% Just an abstraction of a map, scoresheet:fill is basically map:put(field, score).
%%

%% Bonus is for things like scoring greater than 63 points in the section.
-spec new() -> sheet().
new() ->
    % better to only list the derived slots (sum_of_uppers,...) and leave the ones to be
    % filled out of the map - see comment below.
    % And I'd initialise those to 0, not empty.
    #{
        ones => empty,
        twos => empty,
        threes => empty,
        fours => empty,
        fives => empty,
        sixes => empty,
        sum_of_uppers => empty,
        bonus_points => empty,
        one_pair => empty,
        two_pair => empty,
        three_of_a_kind => empty,
        four_of_a_kind => empty,
        small_straight => empty,
        large_straight => empty,
        full_house => empty,
        chance => empty,
        yatzy => empty,
        grand_total => empty
    }.

fill(Field, List, Sheet) ->
    % I'd go straight for the kill:
    % case maps:get(Field, Sheet, empty) of
    %     empty ->
    %         blah;
    %     _ ->
    %         already_filled
    % end.
    % maps:get/3 will save you from having to put in all those empty fields in the
    % starting map.
    case already_filled(Field, Sheet) of
        false ->
            already_filled;
        true ->
            maps:put(Field, List, Sheet), % this one has no effect since you don't pick
            % up the map being returned.
            {ok, maps:put(Field, get_score(Field, List), Sheet)}
            % I'd lean to do this instead:
            % {ok, Sheet#{ Field => get_score(Field, List) }}
            % It feels a bit more Erlangy in some sense.
    end.

already_filled(Field, Sheet) ->
    case maps:get(Field, Sheet) == empty of
        false ->
            false;
        true ->
            true
    end.

-spec get_score(atom(), list()) -> integer().
get_score(ones, List) ->
    yatzy_score:upper(1, List);
get_score(twos, List) ->
    yatzy_score:upper(2, List);
get_score(threes, List) ->
    yatzy_score:upper(3, List);
get_score(fours, List) ->
    yatzy_score:upper(4, List);
get_score(fives, List) ->
    yatzy_score:upper(5, List);
get_score(sixes, List) ->
    yatzy_score:upper(6, List);
get_score(one_pair, List) ->
    % here you can actually go:
    % get_score(Lower, List) ->
    %     yatzy:Lower(List).
    % and avoid all the boilerplate.
    % You may also provied a yatzy_score:calc(Field, List) and have that do the
    % dispatching to the individual scoring functions.
    yatzy_score:one_pair(List);
get_score(two_pair, List) ->
    yatzy_score:two_pair(List);
get_score(three_of_a_kind, List) ->
    yatzy_score:three_of_a_kind(List);
get_score(four_of_a_kind, List) ->
    yatzy_score:four_of_a_kind(List);
get_score(small_straight, List) ->
    yatzy_score:small_straight(List);
get_score(large_straight, List) ->
    yatzy_score:big_straight(List);
get_score(full_house, List) ->
    yatzy_score:full_house(List);
get_score(bonus_points, Map) ->
    yatzy_score:calculate_uppers(Map);
get_score(grand_total, Map) ->
    yatzy_score:grand_total(Map).
