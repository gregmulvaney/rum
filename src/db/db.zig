const std = @import("std");
const Allocator = std.mem.Allocator;
const sqlite = @import("sqlite");

pub const Database = struct {
    db: sqlite.Db,
    alloc: Allocator,

    pub fn init(alloc: Allocator) !?Database {
        const db = try sqlite.Db.init(.{
            .mode = sqlite.Db.Mode{ .File = "/Users/greg/.local/state/rum/state.db" },
            .open_flags = .{
                .write = true,
                .create = true,
            },
            .threading_mode = .MultiThread,
        });

        return Database{
            .alloc = alloc,
            .db = db,
        };
    }
};
