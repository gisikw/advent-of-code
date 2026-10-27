#include "share/atspre_staload.hats"
implement main0 (argc, argv) = let
  val f = (if argc >= 2 then argv[1] else ""): string
  val p = (if argc >= 3 then argv[2] else ""): string
  val inp = fileref_open_exn (f, file_mode_r)
  fun loop (n: int): int = let
    val c = fileref_getc (inp)
  in
    if c < 0 then n else loop (if c = 10 then n + 1 else n)
  end
  val n = loop (0)
  val () = fileref_close (inp)
in
  println! ("Received ", n, " lines of input for part ", p)
end
