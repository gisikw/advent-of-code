#include <fstream>
#include <iostream>
#include <string>
#include <map>
#include <set>
#include <algorithm>

int main(int argc, char *argv[]) {
  std::ifstream file(argv[1]);
  std::string line;
  int part = atoi(argv[2]);
  int size = 496;

  int coords[size][4];

  for (int i = 0; i < size; i++) {
    std::getline(file, line);
    coords[i][0] = stoi(line.substr(0, line.find(",")));
    coords[i][1] = stoi(line.substr(line.find(",") + 1, line.length()));
  };
  
  std::map<int, std::set<int>> verticals;
  std::map<int, std::set<int>> horizontals;

  if (part == 2) {
    // Just so happens no segments are coincident, else we'd need to do pairwise comparisons
    for (int i = 0; i < size; i++) {
      verticals.insert({coords[i][0], std::set<int>()});
      verticals[coords[i][0]].insert(coords[i][1]);

      horizontals.insert({coords[i][1], std::set<int>()});
      horizontals[coords[i][1]].insert(coords[i][0]);
    }
  }

  long max = 0;
  for (int i = 0; i < size; i++) {
    for (int j = i + 1; j < size; j++) {
      long square;

      if (part == 2) {
        int x0 = coords[i][0] < coords[j][0] ? coords[i][0] : coords[j][0];
        int x1 = coords[i][0] < coords[j][0] ? coords[j][0] : coords[i][0];
        int y0 = coords[i][1] < coords[j][1] ? coords[i][1] : coords[j][1];
        int y1 = coords[i][1] < coords[j][1] ? coords[j][1] : coords[i][1];
        
        // 1000% confident this is awful
        for (int x = x0 + 1; x < x1 - 1; x++) {
          if (!verticals[x].empty()) {
            if ((*verticals[x].begin()) <= y0 && (*std::next(verticals[x].begin())) >= y0) goto skip;
            if ((*verticals[x].begin()) <= y1 && (*std::next(verticals[x].begin())) >= y1) goto skip;
          }
        }

        for (int y = y0 + 1; y < y1 - 1; y++) {
          if (!horizontals[y].empty()) {
            if ((*horizontals[y].begin()) <= x0 && (*std::next(horizontals[y].begin())) >= x0) goto skip;
            if ((*horizontals[y].begin()) <= x1 && (*std::next(horizontals[y].begin())) >= x1) goto skip;
          }
        }
      }

      square = (labs(coords[i][0] - coords[j][0]) + 1) * 
               (labs(coords[i][1] - coords[j][1]) + 1);
      if (square > max) {
        max = square;
      }

      skip:;
    }
  };

  std::cout << max << std::endl;

  return 0;
}
