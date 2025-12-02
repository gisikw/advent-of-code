#include <fstream>
#include <iostream>
#include <string>

int main(int argc, char *argv[]) {
    std::ifstream file(argv[1]);
    std::string line;
    int lines = 0;

    while (std::getline(file, line)) {
        lines++;
    }

    std::cout << "Received " << lines << " lines of input for part " << argv[2] << std::endl;
    return 0;
}
