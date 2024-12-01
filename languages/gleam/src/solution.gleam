import gleam/io
import gleam/string
import gleam/list
import gleam/int
import argv
import simplifile

pub fn main() {
  case argv.load().arguments {
    [input_file, part] -> {
      let content = case simplifile.read(from: input_file) {
        Ok(content) -> content
        _ -> "Err"
      }
      let splits = string.split(content, "\n") |> list.length
      let lines = splits - 1 |> int.to_string
      io.println("Received " <> lines <> " lines of input for part " <> part)
    }
    _ -> io.println("Invalid arguments")
  }
}
