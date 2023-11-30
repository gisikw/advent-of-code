import std.stdio;
import std.algorithm;
import std.array;
import std.file;

void main(string[] args) {
    auto inputFile = args[1];
    auto part = args[2];
    auto content = cast(string) readText(inputFile); // Ensure content is treated as string

    // Split the content into lines and count them
    auto linesCount = content.split('\n').filter!(line => !line.empty).count();

    writeln("Received ", linesCount, " lines of input for part ", part);
}
