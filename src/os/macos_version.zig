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

        // TODO: handle error for unknown versions
        const name: []const u8 = switch (semver.major) {
            15 => "Sequoia",
            14 => "Sonoma",
            13 => "Ventura",
            12 => "Monterey",
            else => "Error",
        };

        defer {
            alloc.free(result.stdout);
            alloc.free(result.stderr);
        }

        return MacosVersion{
            .name = name,
            .string = version_string,
            .semver = semver,
        };
    }
};
