const std = @import("std");
const Allocator = std.mem.Allocator;

const FORMULAE_URL: []const u8 = "https://formulae.brew.sh/api/formula.jws.json";

const Formulae = struct {};

const Error = error{FailedFetch};

pub fn fetchFormulae(alloc: Allocator) !void {
    const client = std.http.Client{ .allocator = alloc };
    defer client.deinit();

    const body: std.ArrayList = undefined;
    const result = try client.fetch(.{
        .method = std.http.Method.GET,
        .location = .{ .url = FORMULAE_URL },
        .response_storage = .{ .dynamic = &body },
    });

    if (result.status != 200) {
        return Error.FailedFetch;
    }

    const json = try std.json.parseFromSlice(Formulae, alloc, body, .{});
    _ = json;
}
