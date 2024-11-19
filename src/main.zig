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
        _ = try com.action.run(command.?.options, alloc);
    }
}
