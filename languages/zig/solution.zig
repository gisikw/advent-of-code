const std = @import("std");

pub fn main() !void {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);

    const input_file = args[1];
    const part = args[2];

    const file = try std.fs.cwd().openFile(input_file, .{});
    defer file.close();

    var line_count: usize = 0;
    var buf_reader = std.io.bufferedReader(file.reader());
    while (try buf_reader.reader().readUntilDelimiterOrEofAlloc(
        std.heap.page_allocator, '\n', std.math.maxInt(usize)
    )) |_| : (line_count += 1) {}

    try std.io.getStdOut().writer().print(
        "Received {d} lines of input for part {s}\n", .{ line_count, part }
    );
}
