const std = @import("std");

const Status = enum {
    creating,
    created,
    running,
    stopped,
};

pub const State = struct {
    ociVersion: []const u8,
    id: []const u8,
    status: Status,
    pid: i32,
    bundle: []const u8,
    annotations: std.json.ArrayHashMap([]const u8),
};

pub const Options = struct {
    root: []const u8,
};
