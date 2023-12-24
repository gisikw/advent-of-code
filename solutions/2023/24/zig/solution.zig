const std = @import("std");
const Error = error { None };

pub const Hailstone = struct {
    px: f32,
    py: f32,
    pz: f32,
    vx: f32,
    vy: f32,
    vz: f32
};

pub const Coord = struct {
    x: f32,
    y: f32
};

// System of equations
// 19 + (-2) t = 18 + (-1 j)
// A.px + A.vx t = B.px + B.vx j
// A.vx t + (-B.vx) j = B.px - A.px
//
// 13 + (1) t = 19 + (-1) j
// A.py + A.vy t = B.py + B.vy j
// A.vy t + (-B.vy) j = B.py - A.py
fn collision(A: Hailstone, B: Hailstone) !Coord {
    var a1 = A.vx;
    var b1 = -B.vx;
    var c1 = B.px - A.px;
    var a2 = A.vy;
    var b2 = -B.vy;
    var c2 = B.py - A.py;
    var divisor = (a1 * b2 - b1 * a2);
    if (@fabs(divisor) < 0.000001) return Error.None; // parallel
    var t = (c1 * b2 - b1 * c2) / divisor;
    var j = (a1 * c2 - c1 * a2) / divisor;
    if (t < 0 or j < 0) return Error.None; // Past
    return Coord{ .x = A.px + A.vx * t, .y = A.py + A.vy * t };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    var stones = std.ArrayList(Hailstone).init(allocator);
    defer stones.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    const input_file = args[1];
    const part = args[2];
    _ = part;

    const file = try std.fs.cwd().openFile(input_file, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    while (try buf_reader.reader().readUntilDelimiterOrEofAlloc(
        std.heap.page_allocator, '\n', std.math.maxInt(usize)
    )) |line| {
        var list = std.ArrayList([]const u8).init(allocator);
        defer list.deinit();
        var it = std.mem.tokenizeAny(u8, line, " ,@");
        while (it.next()) |s| {
            try list.append(s);
        }
        try stones.append(Hailstone{
            .px = try std.fmt.parseFloat(f32, list.items[0]),
            .py = try std.fmt.parseFloat(f32, list.items[1]),
            .pz = try std.fmt.parseFloat(f32, list.items[2]),
            .vx = try std.fmt.parseFloat(f32, list.items[3]),
            .vy = try std.fmt.parseFloat(f32, list.items[4]),
            .vz = try std.fmt.parseFloat(f32, list.items[5]),
        });
    }

    const min = 200000000000000;
    const max = 400000000000000;

    var result : i32 = 0;
    for (stones.items, 0..) |a, index| {
        for (stones.items[index+1..]) |b| {
            var coll = collision(a, b);
            if (coll) |c| {
                if (min < c.x and c.x < max and min < c.y and c.y < max) {
                    result += 1;
                }
            } else |_| {}
        }
    }
    try std.io.getStdOut().writer().print("{}\n", .{result});
}
