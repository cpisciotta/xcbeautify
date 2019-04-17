load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "XcbeautifyLib",
    srcs = glob([
        "*.swift",
    ]),
    copts = [
        "-whole-module-optimization",
    ],
    module_name = "XcbeautifyLib",
    visibility = ["//visibility:public"],
    deps = [
        "@Colorizer",
        "@Guaka",
        "@StringScanner",
    ],
)
