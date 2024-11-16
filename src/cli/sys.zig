const std = @import("std");
const Allocator = std.mem.Allocator;
const macos_version = @import("../os/macos_version.zig");
const config = @import("config");

pub fn run(alloc: Allocator) !u8 {
    const stdout = std.io.getStdOut().writer();
    const macos = try macos_version.queryVersion(alloc);

    const info = try std.fmt.allocPrint(alloc, "Rum: v{s}\nmacOS: {s} {s}\n", .{ config.version, macos.name, macos.string });
    _ = try stdout.writeAll(info);
    return 0;
}
