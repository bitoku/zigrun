const std = @import("std");
const Options = @import("struct.zig").Options;

pub fn container_dir(allocator: std.mem.Allocator, container_id: []const u8, options: *const Options) ![]const u8 {
    return std.fs.path.join(allocator, &[_][]const u8{ options.root, container_id });
}

pub fn container_status_path(allocator: std.mem.Allocator, container_id: []const u8, options: *const Options) ![]const u8 {
    return std.fs.path.join(allocator, &[_][]const u8{ try container_dir(allocator, container_id, options), "status" });
}
