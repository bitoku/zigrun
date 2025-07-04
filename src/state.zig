const std = @import("std");
const State = @import("struct.zig").State;
const Options = @import("struct.zig").Options;
const container_status_path = @import("util.zig").container_status_path;

pub fn run(container_id: []const u8, options: *const Options) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();

    const path = try container_status_path(allocator, container_id, options);
    const data = std.fs.cwd().readFileAlloc(allocator, path, 512) catch |err| {
        std.debug.print("Error reading state file: {}\n", .{err});
        std.os.linux.exit(1);
    };
    const state = try std.json.parseFromSliceLeaky(State, allocator, data, .{});

    try std.json.stringify(state, .{}, std.io.getStdOut().writer());
}
