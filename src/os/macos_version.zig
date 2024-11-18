const std = @import("std");
const Allocator = std.mem.Allocator;
const testing = std.testing;

pub const MacosVersion = struct {
    name: []const u8,
    string: []const u8,
    semver: std.SemanticVersion,

    const Error = error{
        InvalidVersion,
        CommandFailed,
    };

    // FIX: add error handling
    pub fn query(alloc: Allocator) !MacosVersion {
        // Use the sw_vers system utility to query the system version number
        const args = [2][]const u8{
            "sw_vers",
            "--productVersion",
        };

        const result = try std.process.Child.run(.{
            .allocator = alloc,
            .argv = &args,
        });

        // Strip newline from command output
        const version_string = std.mem.trim(u8, result.stdout, &std.ascii.whitespace);

        const semver = try std.SemanticVersion.parse(version_string);

        var name: []const u8 = undefined;
        switch (semver.major) {
            15 => name = "Sequoia",
            14 => name = "Sonoma",
            13 => name = "Ventura",
            12 => name = "Monterey",
            else => name = "Error",
        }

        return MacosVersion{
            .name = name,
            .string = version_string,
            .semver = semver,
        };
    }
};
