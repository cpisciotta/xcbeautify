load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "build_bazel_rules_swift",
    sha256 = "31aad005a9c4e56b256125844ad05eb27c88303502d74138186f9083479f93a6",
    url = "https://github.com/bazelbuild/rules_swift/releases/download/0.8.0/rules_swift.0.8.0.tar.gz",
)

load(
    "@build_bazel_rules_swift//swift:repositories.bzl",
    "swift_rules_dependencies",
)

swift_rules_dependencies()

http_archive(
    name = "Colorizer",
    build_file = "//external:External.BUILD",
    strip_prefix = "Colorizer-0.2.0",
    url = "https://github.com/getGuaka/Colorizer/archive/0.2.0.zip",
)

http_archive(
    name = "Guaka",
    build_file = "//external:External.BUILD",
    strip_prefix = "Guaka-0.4.0",
    url = "https://github.com/nsomar/Guaka/archive/0.4.0.zip",
)

http_archive(
    name = "StringScanner",
    build_file = "//external:External.BUILD",
    strip_prefix = "StringScanner-0.4.0",
    url = "https://github.com/getGuaka/StringScanner/archive/0.4.0.zip",
)
