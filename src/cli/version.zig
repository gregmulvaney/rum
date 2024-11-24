const std = @import("std");
const Allocator = std.mem.Allocator;
const config = @import("build_config");

pub fn run(alloc: Allocator) !void {
    _ = alloc;
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Rum v{s} \n", .{config.version});
}
