const std = @import("std");
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;
const testing = std.testing;

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

test "queryVersion returns correct MacOS version information" {
    // Setup
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Execute
    const version = try queryVersion(allocator);

    // Verify
    try testing.expect(version.string.len > 0);
    try testing.expect(version.semver.major >= 12);

    // Test version name mapping
    switch (version.semver.major) {
        15 => try testing.expectEqualStrings("Sequoia", version.name),
        14 => try testing.expectEqualStrings("Sonoma", version.name),
        13 => try testing.expectEqualStrings("Ventura", version.name),
        12 => try testing.expectEqualStrings("Monterey", version.name),
        else => try testing.expectEqualStrings("Error", version.name),
    }

    // Test semver format
    try testing.expect(version.semver.minor >= 0);
    try testing.expect(version.semver.patch >= 0);
}
