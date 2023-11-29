defmodule Solution do
  def main(args) do
    [input_file, part] = args
    content = File.read!(input_file)
    lines_count = content |> String.split("\n", trim: true) |> length

    IO.puts("Received #{lines_count} lines of input for part #{part}")
  end
end

Solution.main(System.argv())
