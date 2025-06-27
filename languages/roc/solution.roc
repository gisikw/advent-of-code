app [main!] { 
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br" 
}

import pf.Stdout
import pf.Path
import pf.Arg

main! = |raw_args|
    args = List.map(raw_args, Arg.display)
    filename = List.get args 1 |> Result.with_default ""
    part = List.get args 2 |> Result.with_default ""

    lineCount =
        filename
        |> Path.from_str
        |> Path.read_utf8!
        |> Result.with_default ""
        |> Str.trim_end
        |> Str.split_on "\n"
        |> List.len
        |> Num.to_str

    Stdout.line! "Received $(lineCount) lines of input for part $(part)"
