const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {
    // Only compile on Darwin
    if (!builtin.os.tag.isDarwin()) {
        @panic("Rum is only for macOS");
    }

    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});
    const options = b.addOptions();

    // Set app version
    const version = std.SemanticVersion{ .major = 0, .minor = 0, .patch = 1 };
    const version_string = std.fmt.comptimePrint("{d}.{d}.{d}", .{ version.major, version.minor, version.patch });

    // Add app version to build config
    options.addOption([]const u8, "version", version_string);

    const exe = b.addExecutable(.{
        .name = "rum",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Package build config options into exe
    exe.root_module.addOptions("build_config", options);

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
