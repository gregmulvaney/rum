const std = @import("std");

pub fn run() !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.writeAll("Heeeeelllppp\n");
}
