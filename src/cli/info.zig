const std = @import("std");
const Allocator = std.mem.Allocator;
const macos_version = @import("../os/macos_version.zig");
const config = @import("build_config");

pub fn run(alloc: Allocator) !void {
    const stdout = std.io.getStdOut().writer();
    const macos = try macos_version.MacosVersion.query(alloc);

    // PERF: Adjust buffer size to better fit usecase
    var buf: [1024]u8 = undefined;
    const app_version = try std.fmt.bufPrint(&buf, "Rum: v{s}\n", .{config.version});
    try stdout.writeAll(app_version);
    const os_version = try std.fmt.bufPrint(&buf, "macOS: {s} v{d}.{d}.{d}\n", .{ macos.name, macos.semver.major, macos.semver.minor, macos.semver.patch });
    try stdout.writeAll(os_version);
}
