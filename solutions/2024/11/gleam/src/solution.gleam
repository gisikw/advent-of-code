import gleam/io
import gleam/string
import gleam/list
import gleam/int
import gleam/dict
import gleam/float
import gleam/result
import argv
import simplifile

pub fn main() {
  case argv.load().arguments {
    [input_file, part] -> {
      let content = case simplifile.read(from: input_file) {
        Ok(content) -> content
        _ -> "Err"
      }

      let nums = content 
        |> string.trim_end 
        |> string.split(" ")
        |> list.map(fn(n) { #(int.parse(n) |> result.unwrap(0), 1) })

      let times = case part {
        "1" -> 25
        _ -> 75
      }

      io.println(nums |> blink_times(times) |> sum |> int.to_string)
    }
    _ -> io.println("Invalid arguments")
  }
}

fn blink_times(rocks, times) {
  case times {
    0 -> rocks
    _ -> blink_times(merge(blink(rocks)), times - 1)
  }
}

fn sum(rocks: List(#(Int, Int))) {
  rocks
    |> list.map(fn(pair) { pair.1 })
    |> list.fold(0, int.add)
}

fn merge(rocks: List(#(Int, Int))) {
  rocks
    |> list.group(by: fn(i) { i.0 })
    |> dict.to_list
    |> list.map(fn(group) {
        #(group.0, 
          group.1 
            |> list.map(fn(pair) { pair.1 })
            |> list.fold(0, int.add))
      })
}

fn blink(rocks) {
  list.flat_map(rocks, fn(rock) {
    let #(value, count) = rock
    case value {
      0 -> [#(1, count)]
      _ -> {
        let dig = digits(value)
        case dig % 2 == 0 {
          True -> {
            let dig = int.divide(dig, 2) |> result.unwrap(1) |> int.to_float
            let mask = int.power(10, dig) |> result.unwrap(1.) |> float.truncate
            [
              #(int.divide(value, mask) |> result.unwrap(1), count),
              #(value % mask, count)
            ]
          }
          False -> [#(value * 2024, count)]
        }
      }
    }
  })
}

fn digits(num) {
  num
    |> int.digits(10)
    |> result.unwrap([])
    |> list.length
}
