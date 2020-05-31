load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "Colorizer",
    srcs = glob([
        "Sources/Colorizer/*.swift",
    ]),
    visibility = ["//visibility:public"],
)

swift_library(
    name = "Guaka",
    srcs = glob([
        "Sources/Guaka/**/*.swift",
    ]),
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
    visibility = ["//visibility:public"],
)
