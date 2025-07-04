//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");
const state = @import("state.zig");
const create = @import("create.zig");
const Options = @import("struct.zig").Options;
const constants = @import("const.zig");

pub fn main() !void {
    // Check if the user has provided a command
    if (std.os.argv.len <= 2) {
        std.debug.print("Usage: {s} <command> <container_id> [options]\n", .{std.os.argv[0]});
        std.os.linux.exit(1);
    }
    const command = std.mem.span(std.os.argv[1]);
    const container_id = std.mem.span(std.os.argv[2]);

    var options = Options{
        .root = constants.default_root,
    };

    for (std.os.argv) |arg| {
        const arg_str = std.mem.span(arg);
        if (std.mem.eql(u8, arg_str, "--root")) {
            options.root = arg_str;
        }
    }

    if (std.mem.eql(u8, command, "state")) {
        try state.run(container_id, &options);
    } else if (std.mem.eql(u8, command, "create")) {
        try create.run(container_id, &options);
    } else {
        std.debug.print("Unknown command: {s}\n", .{command});
        std.os.linux.exit(1);
    }
}
