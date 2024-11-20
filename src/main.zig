const std = @import("std");
const cli = @import("cli.zig");
const config = @import("config.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) @panic("Memory leak detected!");
    }

    try config.dir.checkDirs();

    const command = try cli.Command.parseArgs(alloc);
    if (command) |com| {
        _ = try com.action.run(command.?.options, alloc);
    }
}
