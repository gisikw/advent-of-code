-module(solution).
-export([main/1]).

main([InputFile, Part]) ->
    {ok, BinaryContent} = file:read_file(InputFile),
    Content = binary_to_list(BinaryContent),
    Lines = string:split(rtrim(Content, "\n"), "\n", all),
    LinesCount = length(Lines),
    io:format("Received ~p lines of input for part ~s~n", [LinesCount, Part]).

rtrim(String, Char) ->
    case lists:reverse(String) of
        [$\n | Rest] -> lists:reverse(Rest);
        _ -> String
    end.
