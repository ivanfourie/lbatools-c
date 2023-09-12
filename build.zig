const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "cli-tools",
        .root_source_file = .{ .path = "cli-tools/comp_test.c" },
        .target = target,
        .optimize = optimize,
    });

    exe.linkLibC();
    // Add all the C files in src directory
    exe.addIncludePath(.{ .path = "include" });
    exe.addCSourceFiles(&src_files, &.{ "-std=c99", "-fomit-frame-pointer", "-mstackrealign", "-Wall", "-fno-strict-aliasing", "-Wno-error=int-conversion" });

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}

const src_files = [_][]const u8{
    "compress/compress.c",
    "compress/lzmit.c",
    "compress/lzss.c",
};
