defmodule Solution do
  def main(args) do
    [input_file, part] = args
    File.read!(input_file)
      |> String.split("\n", trim: true)
      |> Task.async_stream(&variations(part,&1), ordered: false, max_concurrency: 100, timeout: :infinity)
      |> Enum.reduce(0, fn { :ok, n }, acc -> acc + n end)
      |> IO.puts
  end

  def variations(part, line) do
    [springs, sums] = String.split(line, " ") 
    springs = if part == "1", do: springs, else: springs |> List.duplicate(5) |> Enum.join("?")
    sums = if part == "1", do: sums, else: sums |> List.duplicate(5) |> Enum.join(",")
    { res, _ } = match(
      springs |> String.replace(~r/\.{2,}/,".") |> String.replace_leading(".", "") |> String.split("", trim: true),
      sums |> String.split(",") |> Enum.map(fn i -> String.to_integer(i) end)
    )
    res
  end

  def match(spr, seqs, cache \\ %{})
  def match(spr, [], cache) do
    score = if "#" in spr, do: 0, else: 1
    { score, cache |> Map.put({spr,[]}, score) }
  end
  def match([], seqs, cache), do: { 0, cache |> Map.put({[],seqs}, 0) }
  def match(spr, seqs, cache) do
    case cache[{spr, seqs}] do
      nil -> 
        [seq | rest] = seqs
        case chomp_seq(spr, seq) do
          { :exact, rem } -> match(rem, rest, cache)
          { :fuzzy, rem } -> 
            [ _ | tail ] = spr
            { score1, cache1 } = match(rem, rest, cache)
            { score2, cache2 } = match(chomp_spaces(tail), seqs, cache1)
            score = score1 + score2
            { score, cache2 |> Map.put({spr,seqs}, score) }
          { :none, _ } -> 
            case spr do
              [ "#" | _ ] -> { 0, cache |> Map.put({spr,seqs},0) }
              [ _ | tail ] -> match(chomp_spaces(tail), seqs, cache)
            end
        end
      score -> { score, cache }
    end
  end

  def chomp_seq(spr, seq) do
    input = spr |> chomp_spaces
    case [input, input |> chomp_maybes(seq)] do
      [_, nil] -> { :none, nil }
      [["#"|_], result] -> { :exact, result }
      [_, result] -> { :fuzzy, result }
    end
  end

  def chomp_spaces([]), do: []
  def chomp_spaces(["."|rest]), do: chomp_spaces(rest)
  def chomp_spaces(spr), do: spr

  def chomp_maybes([], 0), do: []
  def chomp_maybes([], _), do: nil
  def chomp_maybes(["#"|_], 0), do: nil
  def chomp_maybes([_|rest], 0), do: chomp_spaces(rest)
  def chomp_maybes(["."|_],_), do: nil
  def chomp_maybes([_|rest],n), do: chomp_maybes(rest, n-1)

end

Solution.main(System.argv())
