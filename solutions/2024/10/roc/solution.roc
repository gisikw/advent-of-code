app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.17.0/lZFLstMUCUvd5bjnnpYromZJXkQUrdhbva4xdBInicE.tar.br" }

import pf.Stdout
import pf.Env
import pf.Path exposing [Path]

main =
  filename = readEnvVar! "FILENAME"
  part = readEnvVar! "PART"
  content = readFileToStr! (Path.fromStr filename)
  grid = parseGrid content
  grid
    |> trailheads
    |> List.map \trailhead ->
      travel grid 0 part [trailhead] |> List.len
    |> List.sum
    |> Num.toStr
    |> Stdout.line!

travel = \grid, level, part, coords ->
  if level == 9 then
    if part == "1" then
      coords |> Set.fromList |> Set.toList
    else
      coords
  else
    travel grid (level + 1) part
      (List.walk coords [] (\acc, coord -> 
        List.concat acc (neighbors grid coord level)))

neighbors = \grid, (row, col), level ->
  [ (row, col + 1),
    (row, col - 1),
    (row + 1, col),
    (row - 1, col),
  ] |> List.keepIf \coord ->
    (gridAt grid coord) == level + 1

trailheads : List (List U8) -> List (I64, I64)
trailheads = \grid ->
  List.walkWithIndex grid [] 
    \acc, row, r -> 
      List.concat acc (
        List.walkWithIndex row []
          \racc, char, c -> 
            if char != 48 then
              racc
            else 
              List.append racc (Num.intCast r, Num.intCast c))

gridAt : List (List U8), (I64, I64) -> U64
gridAt = \grid, (row, col) ->
  if row < 0 || col < 0 then
    10
  else
    byte = (grid
      |> List.get (Num.intCast row)
      |> Result.withDefault []
      |> List.get (Num.intCast col)
      |> Result.withDefault 58)
    Num.intCast (byte - 48)

parseGrid = \content ->
  content
    |> Str.splitOn "\n"
    |> List.map Str.toUtf8
    |> List.dropIf List.isEmpty

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
      \fileReadErr ->
        when fileReadErr is
          FileReadErr _ _ ->
            ReadFileErr "Failed to read file"
          FileReadUtf8Err _ _ ->
            ReadFileErr "Error reading file"
