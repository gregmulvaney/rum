const std = @import("std");

pub fn directoryExists(path: []const u8) !bool {
    const stat = std.fs.cwd().statFile(path) catch |err| {
        if (err == error.FileNotFound) return false;
        return err;
    };
    return stat.kind == .directory;
}
