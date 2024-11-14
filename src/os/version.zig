const std = @import("std");
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;

pub const MacosVersion = struct {
    name: []const u8,
    string: []const u8,
    semver: std.SemanticVersion,
};

pub fn queryVersion(alloc: Allocator) !MacosVersion {
    const args = [2][]const u8{
        "sw_vers",
        "-productVersion",
    };

    const result = try std.process.Child.run(.{
        .allocator = alloc,
        .argv = &args,
    });

    const version_string: []const u8 = std.mem.trim(u8, result.stdout, &std.ascii.whitespace);

    const semver = try std.SemanticVersion.parse(version_string);

    var name: []const u8 = undefined;
    switch (semver.major) {
        15 => name = "Sequoia",
        14 => name = "Sonoma",
        13 => name = "Ventura",
        12 => name = "Monterey",
        // TODO: Handle errors
        else => name = "Error",
    }

    return .{
        .string = version_string,
        .semver = semver,
        .name = name,
    };
}
