const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList([]const u8);
const ArgIterator = std.process.ArgIterator;
const version = @import("version.zig");
const info = @import("info.zig");
const init = @import("init.zig");
const update = @import("update.zig");

pub const Command = struct {
    action: ?Action,
    options: ?ArrayList,

    pub fn parseArgs(alloc: Allocator) !?Command {
        var args = try std.process.argsWithAllocator(alloc);
        defer args.deinit();
        return try iterArgs(alloc, &args);
    }

    fn iterArgs(alloc: Allocator, args: *ArgIterator) !?Command {
        // Skip program name arg
        _ = args.skip();

        var action: ?Action = null;
        var options = ArrayList.init(alloc);

        var i: usize = 0;
        while (args.next()) |arg| : (i += 1) {
            if (arg.len == 0) continue;

            // Parse first arg as an action
            if (i == 0) {
                action = Action.parseAction(arg) catch {
                    std.debug.print("Invalid Command", .{});
                    return null;
                };
                continue;
            }
            // Parse any remaining arguments as options for the action
            try options.append(arg);
        }

        if (action != null) return Command{ .action = action, .options = options };

        return null;
    }
};

pub const Action = enum {
    version,
    info,
    init,
    update,

    const Error = error{
        InvalidAction,
    };

    fn parseAction(arg: []const u8) Error!?Action {
        const action = std.meta.stringToEnum(Action, arg[0..]) orelse return Error.InvalidAction;
        return action;
    }

    pub fn run(self: Action, alloc: Allocator, options: ArrayList) !void {
        defer options.deinit();
        switch (self) {
            .version => try version.run(alloc),
            .info => try info.run(alloc),
            .init => try init.run(alloc),
            .update => try update.run(alloc),
        }
    }
};
