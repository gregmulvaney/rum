const std = @import("std");
const cli = @import("cli.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) @panic("Memory leak detected!");
    }
    const action = try cli.Action.parseArgs(alloc);
    if (action) |command| {
        _ = try command.action.run(command.options.?, alloc);
    }
}
