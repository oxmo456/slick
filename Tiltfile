def extract_target_deps(target):
    query = 'kind("source file", deps("%s"))' % target
    labels = str(local("bazel query '%s'" % query, quiet = True)).splitlines()
    paths = []
    for label in labels:
        if label.startswith("@"):
            continue
        path = label.lstrip("/").replace(":", "/")
        paths.append(path)

    return paths

local_resource(
    "slock",
    serve_cmd = "ibazel run //apps/slock:serve",
    links = ["http://localhost:5173/"],
)

k8s_resource("slick", port_forwards = "9000:8080")
k8s_yaml("k8s/slick.yaml")
custom_build(
    ref = "slick/slick",
    command = "bazel run //apps/slick:slick-load -- --norun",
    deps = extract_target_deps("//apps/slick:slick-load"),
    tag = "latest",
)
