const std = @import("std");
const Allocator = std.mem.Allocator;
// TODO: Move constants to a different location
const init = @import("../cli/init.zig");

const FORMULA_LIST_URL = "https://formulae.brew.sh/api/formula.jws.json";

pub fn fetch(alloc: Allocator) !void {
    const client = std.http.Client{ .allocator = alloc };
    defer client.deinit();

    const home_dir = try std.process.getEnvVarOwned(alloc, "HOME");

    var buf: [100]u8 = undefined;
    const api_path = std.fmt.bufPrint(&buf, "{s}{s}/api", .{ home_dir, init.CACHE_DIR_PATH });
}
