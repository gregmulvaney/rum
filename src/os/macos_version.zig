const std = @import("std");
const Allocator = std.mem.Allocator;

pub const MacosVersion = struct {
    name: []const u8,
    semver: std.SemanticVersion,

    pub const Error = error{
        InvalidVersion,
    };

    pub fn query(alloc: Allocator) !MacosVersion {
        const args = [2][]const u8{
            "sw_vers",
            "--productVersion",
        };

        const result = try std.process.Child.run(.{
            .allocator = alloc,
            .argv = &args,
        });

        defer {
            alloc.free(result.stdout);
            alloc.free(result.stderr);
        }

        const version_string = std.mem.trim(u8, result.stdout, &std.ascii.whitespace);
        const semver = try std.SemanticVersion.parse(version_string);

        const name: []const u8 = switch (semver.major) {
            15 => "Sequioa",
            14 => "Sonoma",
            13 => "Ventura",
            12 => "Monterey",
            else => "Error",
        };

        return MacosVersion{
            .name = name,
            .semver = semver,
        };
    }
};
