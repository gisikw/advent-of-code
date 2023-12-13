defmodule Solution do
  def main(args) do
    [input_file, part] = args

    File.read!(input_file)
    |> String.split("\n", trim: true)
    |> Task.async_stream(&variations(part, &1),
      ordered: false,
      max_concurrency: 8,
      timeout: :infinity
    )
    |> Enum.reduce(0, fn {:ok, n}, acc -> acc + n end)
    |> IO.puts()
  end

  def variations(part, line) do
    {springs, sums} = parse_line(part, line)
    {res, _} = match(prepare_springs(springs), prepare_sums(sums))
    res
  end

  def parse_line("1", line) do
    [springs, sums] = String.split(line, " ")
    {springs, sums}
  end

  def parse_line("2", line) do
    [springs, sums] = String.split(line, " ")
    {springs |> List.duplicate(5) |> Enum.join("?"), sums |> List.duplicate(5) |> Enum.join(",")}
  end

  def prepare_springs(springs) do
    springs
    |> String.replace(~r/\.{2,}/, ".")
    |> String.replace_leading(".", "")
    |> String.split("", trim: true)
  end

  def prepare_sums(sums) do
    sums
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def match(spr, seqs, cache \\ %{})

  def match(spr, [], cache) do
    score = if "#" in spr, do: 0, else: 1
    {score, Map.put(cache, {spr, []}, score)}
  end

  def match([], seqs, cache) do
    {0, Map.put(cache, {[], seqs}, 0)}
  end

  def match(spr, seqs, cache) when is_map_key(cache, {spr, seqs}) do
    {cache[{spr, seqs}], cache}
  end

  def match(spr, seqs, cache) do
    [seq | rest] = seqs

    case chomp_seq(spr, seq) do
      {:exact, rem} -> match(rem, rest, cache)
      {:fuzzy, rem} -> process_fuzzy_match(spr, seqs, cache, rem, rest)
      {:none, _} -> process_no_match(spr, seqs, cache)
    end
  end

  def process_fuzzy_match(spr, seqs, cache, rem, rest) do
    {score1, cache1} = match(rem, rest, cache)
    {score2, cache2} = match(chomp_spaces(tl(spr)), seqs, cache1)
    {score1 + score2, Map.put(cache2, {spr, seqs}, score1 + score2)}
  end

  def process_no_match(spr, seqs, cache) when hd(spr) == "#" do
    {0, Map.put(cache, {spr, seqs}, 0)}
  end

  def process_no_match([_ | tail], seqs, cache) do
    match(chomp_spaces(tail), seqs, cache)
  end

  def chomp_seq(spr, seq) do
    input = chomp_spaces(spr)
    chomped = chomp_maybes(input, seq)

    cond do
      chomped == nil ->
        {:none, nil}

      hd(input) == "#" ->
        {:exact, chomped}

      true ->
        {:fuzzy, chomped}
    end
  end

  def chomp_spaces([]), do: []
  def chomp_spaces(["." | rest]), do: chomp_spaces(rest)
  def chomp_spaces(spr), do: spr

  def chomp_maybes([], 0), do: []
  def chomp_maybes([], _), do: nil
  def chomp_maybes(["#" | _], 0), do: nil
  def chomp_maybes([_ | rest], 0), do: chomp_spaces(rest)
  def chomp_maybes(["." | _], _), do: nil
  def chomp_maybes([_ | rest], n), do: chomp_maybes(rest, n - 1)
end

Solution.main(System.argv())
