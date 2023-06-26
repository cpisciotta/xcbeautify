// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "xcbeautify",
    products: [
        .executable(name: "xcbeautify", targets: ["xcbeautify"]),
        .library(name: "XcbeautifyLib", targets: ["XcbeautifyLib"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "1.0.1")),
        .package(url: "https://github.com/getGuaka/Colorizer.git", .upToNextMinor(from: "0.2.1")),
        .package(url: "https://github.com/MaxDesiatov/XMLCoder.git", .upToNextMinor(from: "0.13.1")),
    ],
    targets: [
        .target(
            name: "XcbeautifyLib",
            dependencies: [
                "Colorizer",
                "XMLCoder"
            ]),
        .target(
            name: "xcbeautify",
            dependencies: [
                "XcbeautifyLib",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "XcbeautifyLibTests",
            dependencies: ["XcbeautifyLib"]),
    ]
)
