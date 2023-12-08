-module(solution).
-export([main/1]).

main([InputFile, Part]) ->
    {ok, BinaryContent} = file:read_file(InputFile),
    Content = binary_to_list(BinaryContent),
    [ Path | [ _ | NodeLines ] ] = string:split(rtrim(Content), "\n", all),
    Route = parse_path(Path),
    Nodes = make_nodes(NodeLines, dict:new()),
    Result = case Part of 
               "1" -> traverse("AAA", 0, Route, Nodes, fun is_zzz/1);
                 _ -> GhostNodes = find_ghost_nodes(Nodes),
                      Loops = sort_descending(get_loop_lengths(GhostNodes, Route, Nodes)),
                      % Laziest LCM
                      Product = lists:foldl(fun (A, B) -> A * B end, 1, Loops),
                      Product * length(Route)
             end,
    io:format("~p~n", [Result]).

get_loop_lengths(StartingNodes, Route, Nodes) ->
  lists:map(
    fun (N) -> trunc(traverse(N, 0, Route, Nodes, fun ends_in_z/1) / length(Route)) end,
    StartingNodes).

% 76 being ASCII "L"
parse_path(String) -> 
  lists:map(fun(C) -> case C of 76 -> 1; _ -> 2 end end, String).

traverse(CurrentNode, Distance, [ Direction | Rest ], Nodes, ArrivedFn) ->
  case ArrivedFn(CurrentNode) of
    true -> Distance;
    _ -> NextNode = element(Direction, dict:fetch(CurrentNode, Nodes)),
         NextRoute = lists:append(Rest, [Direction]),
         traverse(NextNode, Distance + 1, NextRoute, Nodes, ArrivedFn)
  end.

make_nodes([], Dict) -> Dict;
make_nodes([ Head | Tail ], Dict) ->
  [Key, Left, Right] = string:lexemes(Head, " =,()"),
  make_nodes(Tail, dict:store(Key, {Left, Right}, Dict)).

% 65 being ASCII "A"
find_ghost_nodes(Nodes) ->
  lists:filtermap(
    fun(C) -> case ends_in_a(C) of true -> {true,C}; _ -> false end end,
    dict:fetch_keys(Nodes)).

rtrim(String) ->
    case lists:reverse(String) of
        [$\n | Rest] -> lists:reverse(Rest);
        _ -> String
    end.

sort_descending(List) -> lists:reverse(lists:sort(List)).

is_zzz("ZZZ") -> true;
is_zzz(_) -> false.

ends_in_a([_,_,65]) -> true;
ends_in_a(_) -> false.

ends_in_z([_,_,90]) -> true;
ends_in_z(_) -> false.
