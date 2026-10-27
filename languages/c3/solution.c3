module solution;
import std::io, std::io::file;
fn void main(String[] args)
{
  char[] data = file::load_temp(args[1])!!;
  usz n = 0;
  foreach (c : data) if (c == '\n') n++;
  io::printfn("Received %d lines of input for part %s", n, args[2]);
}
