const std = @import("std");
const cli = @import("cli.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    const action = try cli.Action.parseArgs(alloc);
    if (action) |arg| {
        _ = try arg.run(alloc);
    }
}
