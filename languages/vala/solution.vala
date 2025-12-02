void main (string[] args) {
    var input_file = args[1];
    var part = args[2];

    try {
        string contents;
        FileUtils.get_contents(input_file, out contents);

        var lines = contents.split("\n").length - 1;

        stdout.printf("Received %d lines of input for part %s\n", lines, part);
    } catch (FileError e) {
        stderr.printf("%s\n", e.message);
    }
}
