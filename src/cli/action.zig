const std = @import("std");
const Allocator = std.mem.Allocator;
const version = @import("version.zig");
const system = @import("system.zig");
const ArgIterator = std.process.ArgIterator;

pub const Command = struct {
    action: Action,
    options: ?std.ArrayList([]const u8),
};

pub const Action = enum {
    version,
    system,

    pub const Error = error{
        InvalidCommand,
        OutOfMemory,
    };

    pub fn parseArgs(alloc: Allocator) !?Command {
        var args = try std.process.argsWithAllocator(alloc);
        defer args.deinit();
        return try iterArgs(&args, alloc);
    }

    pub fn iterArgs(args: anytype, alloc: Allocator) Error!?Command {
        var command: Command = undefined;

        var options = std.ArrayList([]const u8).init(alloc);

        var i: usize = 0;
        while (args.next()) |arg| : (i += 1) {
            // Skip first arg
            if (i == 0) {
                continue;
            }
            // If arg is empty continue
            if (arg.len == 0) continue;
            // Parse first argument as an action
            if (i == 1) {
                command.action = std.meta.stringToEnum(Action, arg[0..]) orelse return Error.InvalidCommand;
                continue;
            }
            // Parse any remaining args as options for the action
            try options.append(arg);
        }

        command.options = options;
        return command;
    }

    pub fn run(self: Action, options: ?std.ArrayList([]const u8), alloc: Allocator) !void {
        return switch (self) {
            .version => try version.run(options, alloc),
            .system => try system.run(alloc),
        };
    }
};
