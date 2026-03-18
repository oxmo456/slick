load("@aspect_rules_js//js:defs.bzl", "js_library")

def slck_vite(name, srcs = [], deps = []):
    def extract_vite_deps(deps):
        def add_vite_suffix(label):
            return label.relative(":{}_vite".format(label.name))

        labels = [Label(dep) for dep in deps]
        labels = [add_vite_suffix(label) for label in labels if not label.name.startswith("node_modules")]

        return labels

    def extract_node_modules_deps(deps):
        return [dep for dep in deps if dep.startswith("//:node_modules")]

    js_library(
        name = "{}_vite".format(name),
        srcs = srcs,
        deps = extract_vite_deps(deps) + extract_node_modules_deps(deps),
        visibility = ["//visibility:public"],
        tags = ["vite"],
    )
