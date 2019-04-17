load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "Colorizer",
    srcs = glob([
        "Sources/Colorizer/*.swift",
    ]),
    copts = [
        "-whole-module-optimization",
    ],
    visibility = ["//visibility:public"],
)

swift_library(
    name = "Guaka",
    srcs = glob([
        "Sources/Guaka/**/*.swift",
    ]),
    copts = [
        "-whole-module-optimization",
    ],
    visibility = ["//visibility:public"],
    deps = [
        "@StringScanner",
    ],
)

swift_library(
    name = "StringScanner",
    srcs = glob([
        "Sources/StringScanner/*.swift",
    ]),
    copts = [
        "-whole-module-optimization",
    ],
    visibility = ["//visibility:public"],
)
