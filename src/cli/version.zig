const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn run(alloc: Allocator) !u8 {
    _ = alloc;
    const stdout = std.io.getStdOut().writer();
    _ = try stdout.writeAll("rootbeer\n");
    return 0;
}
