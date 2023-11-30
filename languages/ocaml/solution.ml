let () =
  let input_file = Sys.argv.(1) in
  let part = Sys.argv.(2) in
  let ic = open_in input_file in
  let rec count_lines acc =
    try
      let _ = input_line ic in
      count_lines (acc + 1)
    with
    | End_of_file -> acc
  in
  let lines_count = count_lines 0 in
  close_in ic;
  Printf.printf "Received %d lines of input for part %s\n" lines_count part
