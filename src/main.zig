const std = @import("std");
const cli = @import("cli.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    const action = try cli.Action.parseArgs(alloc);
    if (action) |arg| {
        _ = try arg.run(alloc);
    }
}
