class Solution {
    static public function main() {
        var args = Sys.args();
        var inputFile = args[0];
        var part = args[1];
        var content = sys.io.File.getContent(inputFile);
        var lines = content.split("\n").filter(s -> s != "");
        var linesCount = lines.length;

        trace('Received $linesCount lines of input for part $part');
    }
}
