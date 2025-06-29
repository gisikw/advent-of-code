class Solution {
    static public function main() {
        var args = Sys.args();
        var inputFile = args[0];
        var part = args[1];
        var content = sys.io.File.getContent(inputFile);
        var nums = content.split("\n").filter(s -> s != "").map(Std.parseInt);

        var sequences = [];

        var sum:haxe.Int64 = 0;
        for (n in nums) {
            var sequence = [];
            for (i in 0...2000) {
                n = (n ^ (n << 6)) & 16777215;
                n = (n ^ (n >> 5)) & 16777215;
                n = (n ^ (n << 11)) & 16777215;
                sequence.push(n % 10);
            }
            sequences.push(sequence);
            sum += n;
        }

        if (part == "1") {
            Sys.println('$sum');
            return;
        }

        var windows = new Map();
        for (seq in sequences) {
            var seen = [];
            for (i in 4...2000) {
                var key = [];
                key.push(seq[i-3] - seq[i-4]);
                key.push(seq[i-2] - seq[i-3]);
                key.push(seq[i-1] - seq[i-2]);
                key.push(seq[i] - seq[i-1]);
                var strKey = haxe.Serializer.run(key);
                if (seen.contains(strKey)) continue;
                seen.push(strKey);
                if (windows[strKey] == null) {
                    windows[strKey] = seq[i];
                } else {
                    windows[strKey] += seq[i];
                }
            }
        }

        var max = 0;
        for (val in windows) if (val > max) max = val;

        Sys.println(max);
    }
}
