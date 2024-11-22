const std = @import("std");
const Allocator = std.mem.Allocator;
const ArgIterator = std.process.ArgIterator;
const version = @import("version.zig");
const info = @import("info.zig");

pub const Command = struct {
    action: ?Action,
    options: ?std.ArrayList([]const u8),

    const Error = error{
        InvalidAction,
        OutOfMemory,
    };

    pub fn parseArgs(alloc: Allocator) !?Command {
        var args = try std.process.argsWithAllocator(alloc);
        defer args.deinit();
        return try iterArgs(&args, alloc);
    }

    pub fn iterArgs(args: *ArgIterator, alloc: Allocator) Error!?Command {
        // Skip first argument of program name
        _ = args.skip();

        var action: ?Action = null;
        var options = std.ArrayList([]const u8).init(alloc);

        // Argument index
        var i: usize = 0;
        while (args.next()) |arg| : (i += 1) {
            if (arg.len == 0) continue;

            // Parse first arg as action
            if (i == 0) {
                action = try Action.parseAction(arg) orelse return Error.InvalidAction;
                continue;
            }

            // Parse any remaining args as options
            try options.append(arg);
        }

        if (action != null) return Command{ .action = action, .options = options };

        return null;
    }
};

pub const Action = enum {
    version,
    info,

    const Error = error{
        InvalidAction,
    };

    pub fn parseAction(arg: []const u8) Error!?Action {
        const action = std.meta.stringToEnum(Action, arg[0..]) orelse return Error.InvalidAction;
        return action;
    }

    pub fn run(self: Action, options: ?std.ArrayList([]const u8), alloc: Allocator) !void {
        defer (options.?.deinit());
        switch (self) {
            .version => try version.run(alloc),
            .info => try info.run(alloc),
        }
    }
};
