-module(solution).
-export([main/1]).

main([InputFile, Part]) ->
    {ok, BinaryContent} = file:read_file(InputFile),
    Content = binary_to_list(BinaryContent),
    [ Path | [ _ | NodeLines ] ] = string:split(rtrim(Content), "\n", all),
    Route = parse_path(Path),
    Nodes = make_nodes(NodeLines),
    Result = case Part of 
               "1" -> traverse("AAA", Route, Nodes, fun is_zzz/1);
                 _ -> GhostNodes = find_ghost_nodes(Nodes),
                      Loops = sort_descending(get_loop_lengths(GhostNodes, Route, Nodes)),
                      Product = lists:foldl(fun (A, B) -> A * B end, 1, Loops), % Laziest LCM
                      Product * length(Route)
             end,
    io:format("~p~n", [Result]).

% Lazy assumption: len(A->Z) == len(Z->Z)
get_loop_lengths(StartingNodes, Route, Nodes) ->
  [trunc(traverse(N, Route, Nodes, fun ends_in_z/1) / length(Route)) || N <- StartingNodes].

parse_path(String) -> 
  [if C == $L -> 1; true -> 2 end || C <- String].

traverse(Node, Route, Nodes, Pred) -> traverse(Node, Route, Nodes, Pred, 0, Route).
traverse(Node, Route, Nodes, Pred, Distance, InitialRoute) ->
  case Pred(Node) andalso Route == InitialRoute of
    true -> Distance;
    _ -> [ Direction | Rest ] = Route,
         NextNode = element(Direction, maps:get(Node, Nodes)),
         NextRoute = lists:append(Rest, [Direction]),
         traverse(NextNode, NextRoute, Nodes, Pred, Distance + 1, InitialRoute)
  end.

make_nodes(Lines) -> make_nodes(Lines, maps:new()).
make_nodes([], Map) -> Map;
make_nodes([ Head | Tail ], Map) ->
  [Key, Left, Right] = string:lexemes(Head, " =,()"),
  make_nodes(Tail, Map#{Key => {Left, Right}}).

find_ghost_nodes(Nodes) ->
    [C || C <- maps:keys(Nodes), ends_in_a(C)].

rtrim(String) ->
    case lists:reverse(String) of
        [$\n | Rest] -> lists:reverse(Rest);
        _ -> String
    end.

sort_descending(List) -> lists:reverse(lists:sort(List)).

is_zzz("ZZZ") -> true;
is_zzz(_) -> false.

ends_in_a([_,_,$A]) -> true;
ends_in_a(_) -> false.

ends_in_z([_,_,$Z]) -> true;
ends_in_z(_) -> false.
