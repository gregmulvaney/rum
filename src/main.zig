const std = @import("std");
const cli = @import("cli.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) @panic("Memory leak detected!");
    }

    const command = try cli.Command.parseArgs(alloc);
    if (command) |com| {
        try com.action.?.run(alloc, com.options.?);
    }
}
