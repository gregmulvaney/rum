const std = @import("std");
const Allocator = std.mem.Allocator;
const config = @import("build_config");

pub fn run(options: std.ArrayList([]const u8), alloc: Allocator) !void {
    _ = alloc;
    for (options.items) |item| {
        std.debug.print("Option {s}\n", .{item});
    }
    const stdout = std.io.getStdOut().writer();
    const version_string = std.fmt.comptimePrint("Rum v{s}\n", .{config.version});
    _ = try stdout.writeAll(version_string);
}
