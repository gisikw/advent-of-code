import std.stdio;
import std.algorithm;
import std.array;
import std.file;
import std.range;
import std.conv;

void push(T)(ref T[] xs, T x) {
  xs ~= x;
}

T pop(T)(ref T[] xs) {
  T x = xs[0];
  moveAll(xs[1 .. $], xs[0 .. $-1]);
  --xs.length;
  return x;
}

void main(string[] args) {
    auto inputFile = args[1];
    auto part = args[2];
    auto content = cast(string) readText(inputFile);
    auto moves = 
      content.split('\n')
        .filter!(line => !line.empty)
        .map!(line => take(line.split(' '),2));

    // string[][] nmoves;
    // foreach(line; content.split('\n')) {
    //   if (line.empty) continue;
    //   auto hexstr = line.split(' ')[2][2 .. $-1];
    //   string dist = to!string(to!int(hexstr[0 .. $-1], 16));
    //   nmoves ~= [[dist, "U"]];
    // }

    // Function extraction is being weird, so...parse the grid size
    int minRow = 0;
    int maxRow = 0;
    int minCol = 0;
    int maxCol = 0;
    int col = 0;
    int row = 0;
    foreach(move; moves) {
      string dir = move[0];
      int num = parse!int(move[1]);
      if (dir == "U") {
        row = row - num;
        minRow = min(minRow, row);
      } else if (dir == "D") {
        row = row + num;
        maxRow = max(maxRow, row);
      } else if (dir == "L") {
        col = col - num;
        minCol = min(minCol, col);
      } else {
        col = col + num;
        maxCol = max(maxCol, col);
      }
    }

    // Add a border to allow for better flood fill
    maxRow++;
    maxCol++;
    minRow--;
    minCol--;

    row = minRow * -1;
    col = minCol * -1;
    int height = maxRow - minRow + 1;
    int width = maxCol - minCol + 1;

    writeln(height, ",", width);

    // START THE MAIN PART 1
    char[][] grid;
    grid.length = height;
    for (int i = 0; i < height; i++) {
      grid[i].length = width;
      for (int j = 0; j < width; j++) {
        grid[i][j] = '.';
      }
    }

    // START IT THO FOR REAL
    grid[row][col] = '#';
    foreach(move; moves) {
      string dir = move[0];
      int num = parse!int(move[1]);
      if (dir == "U") {
        for (int i = 0; i < num; i++) {
          grid[--row][col] = '#';
        }
      } else if (dir == "D") {
        for (int i = 0; i < num; i++) {
          grid[++row][col] = '#';
        }
      } else if (dir == "L") {
        for (int i = 0; i < num; i++) {
          grid[row][--col] = '#';
        }
      } else {
        for (int i = 0; i < num; i++) {
          grid[row][++col] = '#';
        }
      }
    }

    // Try PROPER interior detection - row by row, count the boundaries. If it's odd, we're inside
    // for (int r = 0; r < height; r++) {
    //   // 0 -> out, 1 -> entering wall, 2 -> inside
    //   int state = 0;
    //   for (int c = 0; c < width; c++) {
    //     if (grid[r][c] == '#' && c < width - 1 && grid[r][c+1] != '#' && c > 0 && grid[r][c-1] != '#') {
    //       inside = !inside;
    //     } else if (inside) {
    //       grid[r][c] = '*';
    //     }
    //   }
    // }

    int[] queue;
    queue.push(height-1);
    queue.push(0);

    while (queue.length > 0) {
      int r = queue.pop();
      int c = queue.pop();
      if (r < 0 || r >= height || c < 0 || c >= width) continue;
      if (grid[r][c] != '.') continue;
      grid[r][c] = '_';
      queue.push(r+1);
      queue.push(c);
      queue.push(r-1);
      queue.push(c);
      queue.push(r);
      queue.push(c+1);
      queue.push(r);
      queue.push(c-1);
    }

    // Print the grid
    for (int i = 0; i < height; i++) {
      writeln(grid[i]);
    }

    int count = 0;
    for (int r = 0; r < height; r++) {
      for (int c = 0; c < width; c++) {
        if (grid[r][c] == '#') count++;
        if (grid[r][c] == '.') count++;
      }
    }
  
    writeln(count);
}
