load("@aspect_rules_ts//ts:defs.bzl", "ts_project")

def slck_ts_project(name, srcs = [], deps = []):
    ts_project(
        name = name,
        srcs = srcs,
        declaration = True,
        tsconfig = "//:tsconfig",
        visibility = ["//visibility:public"],
        deps = deps,
    )
