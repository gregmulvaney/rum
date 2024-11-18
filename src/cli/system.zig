const std = @import("std");
const Allocator = std.mem.Allocator;
const macos_version = @import("../os/macos_version.zig");
const config = @import("build_config");

pub fn run(alloc: Allocator) !void {
    const stdout = std.io.getStdOut().writer();
    const macos = try macos_version.MacosVersion.query(alloc);

    const info = try std.fmt.allocPrint(alloc, "Rum: v{s}\nmacOS: {s} {s}\n", .{ config.version, macos.name, macos.string });
    _ = try stdout.writeAll(info);
}