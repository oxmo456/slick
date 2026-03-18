load("@aspect_rules_js//js:defs.bzl", "js_library", "js_run_devserver")
load("@bazel_skylib//rules:copy_file.bzl", "copy_file")
load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@npm//:html-insert-assets/package_json.bzl", html_insert_assets_bin = "bin")
load("//tools:slck_ng_project.bzl", "slck_ng_project")
load("//tools:slck_vite.bzl", "slck_vite")
load("//tools:slck_vite_analog_ts_config.bzl", "slck_vite_analog_ts_config")

def slck_ng_app(name, main, index_template, styles, deps = [], static_deps = []):
    slck_vite(
        name = name,
        srcs = [main],
        deps = deps,
    )

    js_library(
        name = "_{}_index_template".format(name),
        srcs = [index_template],
        tags = ["vite"],
    )

    slck_vite_analog_ts_config(
        name = "_{}_vite_package_json".format(name),
    )

    html_insert_assets_bin.html_insert_assets(
        name = "_{}_vite_index".format(name),
        outs = ["index.html"],
        args = [
                   "--html",
                   "$(rootpath :_{}_index_template)".format(name),
                   "--out",
                   "./{}/index.html".format(native.package_name()),
                   "--stamp",
                   "none",
               ] +
               ["--stylesheets"] + ["$(rootpath %s)" % s for s in styles] +
               ["--scripts"] + [static_dep for static_dep in static_deps] +
               ["--scripts", "--module", "./{}".format(main)],
        srcs = [":_{}_index_template".format(name)] + styles,
        visibility = ["//visibility:private"],
        tags = ["vite"],
    )

    js_run_devserver(
        name = "serve",
        args = [
            "dev",
            "--host",
            "localhost",
            "--open",
            "-c",
            "./tools/vite.config.mjs",
        ],
        env = {
            "ROOT": "./{}/".format(native.package_name()),
        },
        tool = "//tools:vite",
        data = [
            "//tools:vite-config",
            ":{}_vite".format(name),
            ":_{}_vite_index".format(name),
            ":_{}_vite_package_json".format(name),
        ] + styles,
        tags = ["vite"],
    )
