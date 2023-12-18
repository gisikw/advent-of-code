import std.stdio;
import std.algorithm;
import std.array;
import std.file;
import std.range;
import std.conv;
import std.string;

string DIRECTIONS = "RDLU";

void main(string[] args) {
    auto inputFile = args[1];
    auto part = args[2];
    auto content = cast(string) readText(inputFile);
    auto lines = content.split('\n').filter!(line => !line.empty);

    long[][] points;
    long x = 0;
    long y = 0;
    points ~= [x, y];
    long perimeter = 0;

    foreach(line; lines) {
      string[] splits = line.split(' ');
      long dir, dist;
      if (part == "1") {
        dir = to!long(DIRECTIONS.indexOf(splits[0]));
        dist = to!long(splits[1]);
      } else {
        string hexstr = splits[2][2 .. $-1];
        dir = to!long(hexstr[$-1 .. $]);
        dist = to!long(hexstr[0 .. $-1], 16);
      }

      perimeter += dist;

      // From the instruction, construct the next point
      if (dir == 0) x += dist;
      else if (dir == 1) y -= dist;
      else if (dir == 2) x -= dist;
      else if (dir == 3) y += dist;

      points ~= [x, y];
    }

    points.reverse();

    long sum = 0;
    for (int i = 0; i < points.length-1; i++) {
      sum += points[i][0] * points[i+1][1] - points[i+1][0] * points[i][1];
    }

    sum /= 2;
    perimeter /= 2;

    writeln(sum + perimeter + 1); // Magic off-by-one
}
