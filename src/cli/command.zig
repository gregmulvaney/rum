const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const version = @import("version.zig");
const system = @import("system.zig");

pub const Command = struct {
    action: Action,
    options: ArrayList([]const u8),

    pub const Error = error{
        InvalidCommand,
        InvalidAction,
        OutOfMemory,
    };

    pub fn parseArgs(alloc: Allocator) !?Command {
        var args = try std.process.argsWithAllocator(alloc);
        defer args.deinit();
        return try iterArgs(&args, alloc);
    }

    pub fn iterArgs(args: *std.process.ArgIterator, alloc: Allocator) Error!?Command {
        var command: Command = undefined;

        // Create an arraylist for action options
        var options = ArrayList([]const u8).init(alloc);

        // Skip program namex
        _ = args.skip();

        var i: usize = 0;
        while (args.next()) |arg| : (i += 1) {
            // Parse first arg as an action
            if (i == 0) {
                command.action = try Action.parseAction(arg) orelse return Error.InvalidAction;
                continue;
            }

            // Parse any remaining arguments as options
            try options.append(arg);
        }
        command.options = options;
        return command;
    }
};

pub const Action = enum {
    version,
    system,

    pub fn parseAction(action: []const u8) !?Action {
        return std.meta.stringToEnum(Action, action[0..]);
    }

    pub fn run(self: Action, options: ArrayList([]const u8), alloc: Allocator) !void {
        defer options.deinit();
        switch (self) {
            .version => try version.run(options, alloc),
            .system => try system.run(options, alloc),
        }
    }
};
