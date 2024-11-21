const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn checkDirs(alloc: Allocator) !void {
    const opt_stat = try directoryExists("/opt/rum");
    if (!opt_stat) {
        std.debug.print("No opt dir", .{});
    }

    const result = try std.process.Child.run(.{
        .allocator = alloc,
        .argv = &[_][]const u8{ "sudo", "mkdir", "/opt/rum" },
    });

    defer {
        alloc.free(result.stdout);
        alloc.free(result.stderr);
    }

    const result2 = try std.process.Child.run(.{
        .allocator = alloc,
        .argv = &[_][]const u8{ "sudo", "chown", "greg", "/opt/rum" },
    });

    defer {
        alloc.free(result2.stdout);
        alloc.free(result2.stderr);
    }
}

pub fn directoryExists(path: []const u8) !bool {
    const stat = std.fs.cwd().statFile(path) catch |err| switch (err) {
        error.FileNotFound => return false,
        else => return err,
    };
    return stat.kind == .directory;
}
