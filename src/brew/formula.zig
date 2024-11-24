const std = @import("std");
const Allocator = std.mem.Allocator;
const config = @import("../config.zig");

const FORMULA_JSON_URL = "https://formulae.brew.sh/api/formula.jws.json";

pub fn fetch(alloc: Allocator) !void {
    const stdout = std.io.getStdOut().writer();
    var client = std.http.Client{ .allocator = alloc };
    defer client.deinit();

    // TODO: move this to a helper function
    const home_path = try std.process.getEnvVarOwned(alloc, "HOME");
    defer alloc.free(home_path);

    var buf: [100]u8 = undefined;
    const path = try std.fmt.bufPrint(&buf, "{s}/{s}/api/formula.jws.json", .{ home_path, config.CACHE_DIR_PATH });
    try stdout.writeAll(path);

    const file = try std.fs.cwd().createFile(path, .{});
    defer file.close();

    var header_buf: [1024]u8 = undefined;
    const uri = try std.Uri.parse(FORMULA_JSON_URL);
    var request = try client.open(.GET, uri, .{ .server_header_buffer = &header_buf });
    defer request.deinit();

    var buf_writer = std.io.bufferedWriter(file.writer());
    var writer = buf_writer.writer();

    try request.send();
    try request.wait();

    var buffer: [8192]u8 = undefined;
    while (true) {
        const bytes_read = try request.reader().read(&buffer);
        if (bytes_read == 0) break;
        try writer.writeAll(buffer[0..bytes_read]);
    }
    try buf_writer.flush();
}
