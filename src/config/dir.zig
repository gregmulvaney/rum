const std = @import("std");

pub fn checkDirs() !void {
    const opt_stat = try directoryExists("/opt/rum");
    if (!opt_stat) {
        std.debug.print("No opt dir", .{});
    }
}

pub fn directoryExists(path: []const u8) !bool {
    const stat = std.fs.cwd().statFile(path) catch |err| switch (err) {
        error.FileNotFound => return false,
        else => return err,
    };
    return stat.kind == .directory;
}
