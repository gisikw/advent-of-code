import ballerina/io;

configurable string inputFile = ?;
configurable string part = ?;

public function main() returns error? {
    string[] lines = check io:fileReadLines(inputFile);
    io:println("Receieved ", lines.length(), " lines of input for part ", part);
}

