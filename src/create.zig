const std = @import("std");
const Options = @import("struct.zig").Options;
const container_dir = @import("util.zig").container_dir;
const container_status_path = @import("util.zig").container_status_path;

pub fn run(container_id: []const u8, options: *const Options) !void {
    std.debug.print("Creating container {s} in {s}\n", .{ container_id, options.root });
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();

    std.fs.makeDirAbsolute(options.root) catch |err| {
        if (err != error.PathAlreadyExists) {
            return err;
        }
    };

    std.fs.makeDirAbsolute(try container_dir(allocator, container_id, options)) catch |err| {
        if (err != error.PathAlreadyExists) {
            return err;
        }
    };

    const status_path = try container_status_path(allocator, container_id, options);
    const file = std.fs.createFileAbsolute(status_path, .{ .mode = 0o644 }) catch |err| switch (err) {
        error.PathAlreadyExists => try std.fs.openFileAbsolute(status_path, .{ .mode = .read_write }),
        else => return err,
    };

    var b: [255]u8 = undefined;
    const contents = try std.fmt.bufPrint(&b, 
    "{{\"ociVersion\":\"0.2.0\",\"id\":\"{s}\",\"status\":\"running\",\"pid\":4422,\"bundle\":\"/containers/redis\",\"annotations\":{{\"myKey\":\"myValue\"}}}}", 
    .{ container_id });
    file.writeAll(contents) catch |err| {
        return err;
    };
}
