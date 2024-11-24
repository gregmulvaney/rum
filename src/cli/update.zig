const std = @import("std");
const Allocator = std.mem.Allocator;
const formula = @import("../brew/formula.zig");

pub fn run(alloc: Allocator) !void {
    try formula.fetch(alloc);
}
