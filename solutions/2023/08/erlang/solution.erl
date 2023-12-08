-module(solution).
-export([main/1]).

main([InputFile, Part]) ->
    {ok, BinaryContent} = file:read_file(InputFile),
    Content = binary_to_list(BinaryContent),
    [ Route | [ _ | NodeLines ] ] = string:split(rtrim(Content), "\n", all),
    Nodes = make_nodes(NodeLines, dict:new()),
    Result = case Part of 
               "1" -> traverse("AAA", 0, parse_path(Route), Nodes);
                 _ -> GhostNodes = find_ghost_nodes(Nodes),
                      Loops = lists:reverse(lists:sort(lists:map(fun(Node) -> trunc(traverseOne(Node, 0, parse_path(Route), Nodes) / length(Route)) end, GhostNodes))),
                      Product = lists:foldl(fun (A, B) -> A * B end, 1, Loops),
                      Product * length(Route)
             end,
    io:format("~p~n", [Result]).

rtrim(String) ->
    case lists:reverse(String) of
        [$\n | Rest] -> lists:reverse(Rest);
        _ -> String
    end.

% 76 being ASCII "L"
parse_path(String) -> 
  lists:map(fun(C) -> case C of 76 -> 1; _ -> 2 end end, String).

traverse("ZZZ", Distance, _, _) -> Distance;
traverse(CurrentNode, Distance, [ Direction | Rest ], Nodes) ->
  NextNode = element(Direction, dict:fetch(CurrentNode, Nodes)),
  NextRoute = lists:append(Rest, [Direction]),
  traverse(NextNode, Distance + 1, NextRoute, Nodes).

traverseOne([_,_,90], Distance, _, _) -> Distance;
traverseOne(CurrentNode, Distance, [ Direction | Rest ], Nodes) ->
  NextNode = element(Direction, dict:fetch(CurrentNode, Nodes)),
  NextRoute = lists:append(Rest, [Direction]),
  traverseOne(NextNode, Distance + 1, NextRoute, Nodes).

make_nodes([], Dict) -> Dict;
make_nodes([ Head | Tail ], Dict) ->
  [Key, Left, Right] = string:lexemes(Head, " =,()"),
  make_nodes(Tail, dict:store(Key, {Left, Right}, Dict)).

% 65 being ASCII "A"
find_ghost_nodes(Nodes) ->
  lists:filtermap(
    fun(Char) -> 
        [_, _, C] = Char, 
        case C of 65 -> {true,Char}; _ -> false end 
    end, dict:fetch_keys(Nodes)).
