load("ext://helm_resource", "helm_repo", "helm_resource")

local("kubectl get ns ingress-nginx || kubectl create ns ingress-nginx")

helm_repo(
    "ingress-nginx",
    "https://kubernetes.github.io/ingress-nginx",
    resource_name = "ingress-nginx-chart",
    labels = ["ingress"],
)

helm_resource(
    "ingress-nginx",
    "ingress-nginx/ingress-nginx",
    namespace = "ingress-nginx",
    resource_deps = ["ingress-nginx-chart"],
    release_name = "ingress-nginx",
    port_forwards = "5050:80",
    labels = ["ingress"],
    flags = [
        "--version",
        "4.7.1",
        "--set",
        "controller.allowSnippetAnnotations=true",
        "--set",
        "controller.ingressClassResource.name=nginx",
    ],
)

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
k8s_yaml("tools/k8s/slick.yaml")
k8s_yaml("tools/k8s/slick-ws-ingress.yaml")
custom_build(
    ref = "slick/slick",
    command = "bazel run //apps/slick:slick-load -- --norun",
    deps = extract_target_deps("//apps/slick:slick-load"),
    tag = "latest",
)
