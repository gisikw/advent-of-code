app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.17.0/lZFLstMUCUvd5bjnnpYromZJXkQUrdhbva4xdBInicE.tar.br" }

import pf.Stdout
import pf.Env
import pf.Path exposing [Path]

main =
    filename = readEnvVar! "FILENAME"
    part = readEnvVar! "PART"

    content = readFileToStr! (Path.fromStr filename)
    newlineCount = Str.splitOn content "\n" |> List.len
    lineCount = newlineCount - 1 |> Num.toStr

    Stdout.line "Received $(lineCount) lines of input for part $(part)"

readEnvVar : Str -> Task Str []
readEnvVar = \envVarName ->
    when Env.var envVarName |> Task.result! is
        Ok envVarStr if !(Str.isEmpty envVarStr) ->
            Task.ok envVarStr
        _ ->
            Task.ok ""

readFileToStr : Path -> Task Str [ReadFileErr Str]_
readFileToStr = \path ->
    path
    |> Path.readUtf8
    |> Task.mapErr
        (\fileReadErr ->
            pathStr = Path.display path

            when fileReadErr is
                FileReadErr _ readErr ->
                    readErrStr = Inspect.toStr readErr

                    ReadFileErr "Failed to read file:\n\t$(pathStr)\nWith error:\n\t$(readErrStr)"

                FileReadUtf8Err _ _ ->
                    ReadFileErr "Error reading file"
        )
