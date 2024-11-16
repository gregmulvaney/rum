const std = @import("std");
const help = @import("help.zig");
const version = @import("version.zig");
const sys = @import("sys.zig");
const Allocator = std.mem.Allocator;

pub const Action = enum {
    version,
    sys,

    pub fn parseArgs(alloc: Allocator) !?Action {
        var args = try std.process.argsWithAllocator(alloc);
        defer args.deinit();
        var action: ?Action = null;
        while (args.next()) |arg| {
            // TODO: Handle them errors
            action = std.meta.stringToEnum(Action, arg[0..]);
        }
        return action;
    }

    pub fn run(self: Action, alloc: Allocator) !u8 {
        return switch (self) {
            .version => try version.run(alloc),
            .sys => try sys.run(alloc),
        };
    }
};
