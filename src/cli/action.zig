const std = @import("std");
const Allocator = std.mem.Allocator;
const version = @import("version.zig");
const system = @import("system.zig");

pub const Action = enum {
    version,
    system,

    pub const Error = error{
        InvalidCommand,
    };

    pub fn parseArgs(alloc: Allocator) !?Action {
        var args = try std.process.argsWithAllocator(alloc);
        defer args.deinit();

        var action: ?Action = null;

        while (args.next()) |arg| {
            action = std.meta.stringToEnum(Action, arg[0..]);
        }

        return action;
    }

    pub fn run(self: Action, alloc: Allocator) !void {
        return switch (self) {
            .version => try version.run(alloc),
            .system => try system.run(alloc),
        };
    }
};
