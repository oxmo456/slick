load("@aspect_rules_ts//ts:defs.bzl", "ts_project")
load("@bazel_skylib//rules:copy_file.bzl", "copy_file")
load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@npm//:vitest/package_json.bzl", vitest = "bin")
load("//tools:slck_vite.bzl", "slck_vite")
load("//tools:slck_vite_analog_ts_config.bzl", "slck_vite_analog_ts_config")

def slck_ng_project(
        name,
        srcs = [],
        test_srcs = [],
        deps = [],
        test_deps = []):
    slck_vite(
        name = name,
        srcs = srcs,
        deps = deps,
    )

    ts_project(
        name = name,
        srcs = srcs,
        deps = deps +
               ["//:node_modules/tslib"],
        tsc = "//tools:ngc",
        tsconfig = "//:tsconfig",
        visibility = ["//visibility:public"],
        declaration = True,
    )

    if test_srcs:
        slck_vite_analog_ts_config(
            name = "_{}_vite_package_json".format(name),
        )

        copy_file(
            name = "_{}_test_setup".format(name),
            src = "//tools:test-setup.ts",
            out = "test-setup.ts",
            tags = ["vitest"],
        )

        vitest.vitest_test(
            name = "_{}_vitest".format(name),
            args = [
                "run",
                "-c",
                "./tools/vite.config.mjs",
            ],
            env = {
                "ROOT": "./{}/".format(native.package_name()),
            },
            data = [
                "//:node_modules/@analogjs/vitest-angular",
                "//:node_modules/tinyglobby",
                "//:node_modules/zone.js",
                "//:node_modules/jsdom",
                "//:node_modules/@angular/platform-browser",
                "//:node_modules/@angular/platform-browser-dynamic",
                "//:node_modules/@angular/compiler",
                "//:node_modules/@angular/common",
                "//:node_modules/tslib",
                ":_{}_test_setup".format(name),
                ":_{}_vite_package_json".format(name),
                "//tools:vite-config",
            ] + test_srcs + test_deps + srcs + deps,
            tags = ["vitest"],
        )
