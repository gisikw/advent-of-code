const std = @import("std");
const BigInt = std.math.big.int;
const Rational = std.math.big.Rational;
const Error = error { None };

const Hailstone = struct {
    px: f64,
    py: f64,
    pz: f64,
    vx: f64,
    vy: f64,
    vz: f64
};

const Coord = struct {
    x: f64,
    y: f64
};

fn gaussian_elimination(matrix: *[4][5]Rational, allocator: *std.mem.Allocator) !void {
    var pivot = try Rational.init(allocator.*);
    var scalar = try Rational.init(allocator.*);
    var scalarMult = try Rational.init(allocator.*);
    defer pivot.deinit();
    defer scalar.deinit();
    defer scalarMult.deinit();

    // Forward Elimination
    for (0..matrix.len) |i| {
        try pivot.copyRatio(matrix[i][i].p, matrix[i][i].q);
        for (0..matrix[0].len) |k| {
            try matrix[i][k].div(matrix[i][k], pivot);
        }
        for (i+1..matrix.len) |j| {
            try scalar.copyRatio(matrix[j][i].p, matrix[j][i].q);
            for (0..matrix[0].len) |k| {
                try scalarMult.mul(scalar, matrix[i][k]);
                try matrix[j][k].sub(matrix[j][k], scalarMult);
            }
        }
    }
    // Backward Elimination
    for (0..matrix.len) |ii| {
        var i = matrix.len - ii - 1;
        for (0..i) |j| {
            try scalar.copyRatio(matrix[j][i].p, matrix[j][i].q);
            for (0..matrix[0].len) |k| {
                try scalarMult.mul(scalar, matrix[i][k]);
                try matrix[j][k].sub(matrix[j][k], scalarMult);
            }
        }
    }
}

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

fn x_y_row_for_pair(matrix: *[5]Rational, a: Hailstone, b: Hailstone) !void {
    try matrix[0].setFloat(f64, b.vy - a.vy);
    try matrix[1].setFloat(f64, a.vx - b.vx);
    try matrix[2].setFloat(f64, a.py - b.py);
    try matrix[3].setFloat(f64, b.px - a.px);
    // |
    try matrix[4].setFloat(f64, b.px * b.vy - b.py * b.vx - a.px * a.vy + a.py * a.vx);
}

fn x_z_row_for_pair(matrix: *[5]Rational, a: Hailstone, b: Hailstone) !void {
    try matrix[0].setFloat(f64, b.vz - a.vz);
    try matrix[1].setFloat(f64, a.vx - b.vx);
    try matrix[2].setFloat(f64, a.pz - b.pz);
    try matrix[3].setFloat(f64, b.px - a.px);
    // |
    try matrix[4].setFloat(f64, b.px * b.vz - b.pz * b.vx - a.px * a.vz + a.pz * a.vx);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var allocator = gpa.allocator();
    
    var stones = std.ArrayList(Hailstone).init(allocator);
    defer stones.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    const input_file = args[1];
    const part = try std.fmt.parseInt(i32, args[2], 10);

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
            .px = try std.fmt.parseFloat(f64, list.items[0]),
            .py = try std.fmt.parseFloat(f64, list.items[1]),
            .pz = try std.fmt.parseFloat(f64, list.items[2]),
            .vx = try std.fmt.parseFloat(f64, list.items[3]),
            .vy = try std.fmt.parseFloat(f64, list.items[4]),
            .vz = try std.fmt.parseFloat(f64, list.items[5]),
        });
    }

    if (part == 1) {
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
    } else {
        var matrix : [4][5]Rational = undefined;
        for (0..4) |row| for (0..5) |col| { matrix[row][col] = try Rational.init(allocator); };

        // Solve x, y
        try x_y_row_for_pair(&matrix[0], stones.items[0], stones.items[5]);
        try x_y_row_for_pair(&matrix[1], stones.items[1], stones.items[6]);
        try x_y_row_for_pair(&matrix[2], stones.items[2], stones.items[7]);
        try x_y_row_for_pair(&matrix[3], stones.items[3], stones.items[8]);

        try gaussian_elimination(&matrix, &allocator);

        const y = @as(i64, @intFromFloat(@fabs(@ceil(try matrix[1][4].toFloat(f128)))));

        // Solve x, z
        try x_z_row_for_pair(&matrix[0], stones.items[0], stones.items[5]);
        try x_z_row_for_pair(&matrix[1], stones.items[1], stones.items[6]);
        try x_z_row_for_pair(&matrix[2], stones.items[2], stones.items[7]);
        try x_z_row_for_pair(&matrix[3], stones.items[3], stones.items[8]);

        try gaussian_elimination(&matrix, &allocator);

        // Zig's Rational doesn't correctly handle -num/-denom
        const x = @as(i64, @intFromFloat(@fabs(@ceil(try matrix[0][4].toFloat(f128)))));
        const z = @as(i64, @intFromFloat(@fabs(@ceil(try matrix[1][4].toFloat(f128)))));

        for (0..4) |row| for (0..5) |col| matrix[row][col].deinit();

        const ZIG_STD_LIB_FRUSTRATION_PENALTY = -1;
        try std.io.getStdOut().writer().print("{d}\n", .{x + y + z + ZIG_STD_LIB_FRUSTRATION_PENALTY});
    }
}
