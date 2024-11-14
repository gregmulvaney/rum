const std = @import("std");
const Allocator = std.mem.Allocator;
const macos_version = @import("../os/macos_version.zig");

pub fn run(alloc: Allocator) !u8 {
    const stdout = std.io.getStdOut().writer();
    const version = try macos_version.queryVersion(alloc);
    var buf: [100]u8 = undefined;
    const full_version = try std.fmt.bufPrint(&buf, "{s} {s} \n", .{ version.name, version.string });
    _ = try stdout.writeAll(full_version);
    return 0;
}
