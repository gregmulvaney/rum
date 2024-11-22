const std = @import("std");
const Allocator = std.mem.Allocator;

pub const DATA_DIR_PATH: []const u8 = "/opt/rum";
pub const CACHE_DIR_PATH: []const u8 = "/Library/Caches/Rum";

const Error = error{EnvError};

pub fn run(alloc: Allocator) !void {
    const stdout = std.io.getStdOut().writer();

    _ = try stdout.write("Checking if data directory exists \n");

    // Check if /opt/rum exists and create it if not
    if (!try directoryExists(DATA_DIR_PATH)) {
        _ = try stdout.write("Creating data directory in /opt/rum \n");
        try createOptDir(alloc);
        _ = try stdout.write("Chowning data directory \n");
        try chownOptDir(alloc);
    }

    _ = try stdout.write("Checking if cache directory exists\n");
    const home_dir = try std.process.getEnvVarOwned(alloc, "HOME");
    defer alloc.free(home_dir);
    var buf: [100]u8 = undefined;
    const cache_path = try std.fmt.bufPrint(&buf, "{s}{s}", .{ home_dir, CACHE_DIR_PATH });
    if (!try directoryExists(cache_path)) {
        _ = try stdout.write("Creating cache dir at ~/Library/Caches/Rum\n");
        try createCacheDir(home_dir);
    }
}

fn directoryExists(path: []const u8) !bool {
    // Check if path exists
    const stat = std.fs.cwd().statFile(path) catch |err| {
        if (err == error.FileNotFound) return false;
        return err;
    };

    // Check if path is a directory
    return stat.kind == .directory;
}

fn createOptDir(alloc: Allocator) !void {
    const args = [3][]const u8{ "sudo", "mkdir", DATA_DIR_PATH };

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

    const args = [4][]const u8{ "sudo", "chown", user, DATA_DIR_PATH };

    const result = try std.process.Child.run(.{
        .allocator = alloc,
        .argv = &args,
    });

    defer {
        alloc.free(result.stdout);
        alloc.free(result.stderr);
    }
}

fn createCacheDir(home_path: []const u8) !void {
    var buf: [100]u8 = undefined;
    const cache_path = try std.fmt.bufPrint(&buf, "{s}{s}", .{ home_path, CACHE_DIR_PATH });
    try std.fs.cwd().makeDir(cache_path);
}
