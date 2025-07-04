const std = @import("std");
const Options = @import("struct.zig").Options;

pub fn container_dir(allocator: std.mem.Allocator, container_id: []const u8, options: *const Options) ![]const u8 {
    return std.fs.path.join(allocator, &[_][]const u8{ options.root, container_id });
}

pub fn container_status_path(allocator: std.mem.Allocator, container_id: []const u8, options: *const Options) ![]const u8 {
    return std.fs.path.join(allocator, &[_][]const u8{ try container_dir(allocator, container_id, options), "status" });
}

pub fn openOrCreateFile(path: []const u8, mode: std.fs.File.Mode) !std.fs.File {
    return std.fs.openFileAbsolute(path, .{ .mode = mode }) catch |err| switch (err) {
        error.FileNotFound => try std.fs.createFileAbsolute(path, .{ .mode = 0o644 }),
        else => return err,
    };
}
