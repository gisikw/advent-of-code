let read_lines name : string list =
  let ic = open_in name in
  let try_read () =
    try Some (input_line ic) with End_of_file -> None in
  let rec loop acc = match try_read () with
    | Some s -> loop (s :: acc)
    | None -> close_in ic; List.rev acc in
  loop []

let parse_line line =
  line |> String.split_on_char ' ' |> List.map int_of_string

let rec compute_diffs = function
  | a :: b :: rest -> b - a :: compute_diffs (b :: rest)
  | _ -> []

let rec next_of_sequence = function
  | 0 :: rest when List.for_all ((=) 0) rest -> 0
  | h :: t -> h - (compute_diffs (h :: t) |> next_of_sequence)
  | _ -> 0

let order_for part seqs =
  if part = "1" then seqs |> List.map List.rev else seqs

let () =
  let input_file = Sys.argv.(1) in
  let part = Sys.argv.(2) in
  let seqs = read_lines input_file |> List.map parse_line in
  let values = seqs |> order_for part |> List.map next_of_sequence in
  Printf.printf "%d\n" @@ List.fold_left (fun acc i -> acc + i) 0 values
