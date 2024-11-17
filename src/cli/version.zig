const std = @import("std");
const Allocator = std.mem.Allocator;
const config = @import("build_config");

pub fn run(alloc: Allocator) !void {
    _ = alloc;
    const stdout = std.io.getStdOut().writer();
    const version_string = std.fmt.comptimePrint("Rum v{s}\n", .{config.version});
    _ = try stdout.writeAll(version_string);
}
