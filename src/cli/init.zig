const std = @import("std");
const Allocator = std.mem.Allocator;
const util = @import("../util.zig");
const config = @import("../config.zig");

pub fn run(alloc: Allocator) !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.writeAll("Checking if data directory exists at /opt/rum\n");
    if (!try util.directoryExists(config.DATA_DIR_PATH)) {
        try stdout.writeAll("Creating data directory at /opt/rum\n");
        try createOptDir(alloc);
        try stdout.writeAll("Chowing data directory\n");
        try chownOptDir(alloc);
    }

    try stdout.writeAll("Check if cache directory exists at ~/.cache/rum\n");

    const home_path = try std.process.getEnvVarOwned(alloc, "HOME");
    defer alloc.free(home_path);

    var buf: [100]u8 = undefined;
    const cache_path = try std.fmt.bufPrint(&buf, "{s}/{s}", .{ home_path, config.CACHE_DIR_PATH });
    if (!try util.directoryExists(cache_path)) {
        try stdout.writeAll("Creating cache dir...\n");
        try std.fs.cwd().makeDir(cache_path);
    }
    try stdout.writeAll("Rum initialization complete \n");
}

fn createOptDir(alloc: Allocator) !void {
    const args = [3][]const u8{ "sudo", "mkdir", config.DATA_DIR_PATH };

    const result = try std.process.Child.run(.{
        .allocator = alloc,
        .argv = &args,
    });

    defer {
        alloc.free(result.stdout);
        alloc.free(result.stderr);
    }
}

fn chownOptDir(alloc: Allocator) !void {
    // get current user
    const user = try std.process.getEnvVarOwned(alloc, "USER");
    defer alloc.free(user);

    const args = [4][]const u8{ "sudo", "chown", user, config.DATA_DIR_PATH };

    const result = try std.process.Child.run(.{
        .allocator = alloc,
        .argv = &args,
    });

    defer {
        alloc.free(result.stdout);
        alloc.free(result.stderr);
    }
}
