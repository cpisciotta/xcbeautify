load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

git_repository(
    name = "build_bazel_rules_swift",
    commit = "6408d85da799ec2af053c4e2883dce3ce6d30f08",
    remote = "https://github.com/bazelbuild/rules_swift.git",
)

load(
    "@build_bazel_rules_swift//swift:repositories.bzl",
    "swift_rules_dependencies",
)

swift_rules_dependencies()

load(
    "@com_google_protobuf//:protobuf_deps.bzl",
    "protobuf_deps",
)

protobuf_deps()

http_archive(
    name = "Colorizer",
    build_file = "//external:External.BUILD",
    sha256 = "b4bfc4d4172e8ee8be1bbfc39379b821cc93f2551df12ceb95fe5231513058ed",
    strip_prefix = "Colorizer-0.2.0",
    url = "https://github.com/getGuaka/Colorizer/archive/0.2.0.zip",
)

http_archive(
    name = "Guaka",
    build_file = "//external:External.BUILD",
    sha256 = "f8d87ad9bf3e9ad5bdf8e62ea2fe63b6d248991b8044c77e266e53a6538150c5",
    strip_prefix = "Guaka-0.4.0",
    url = "https://github.com/nsomar/Guaka/archive/0.4.0.zip",
)

http_archive(
    name = "StringScanner",
    build_file = "//external:External.BUILD",
    sha256 = "803df39865042391371e7caba5ebf0adf44d2b237cabc75dd6040e9bc4b7477c",
    strip_prefix = "StringScanner-0.4.0",
    url = "https://github.com/getGuaka/StringScanner/archive/0.4.0.zip",
)
