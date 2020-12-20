// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "xcbeautify",
    products: [
        .executable(name: "xcbeautify", targets: ["xcbeautify"]),
        .library(name: "XcbeautifyLib", targets: ["XcbeautifyLib"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.3.1"),
        .package(url: "https://github.com/getGuaka/Colorizer.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "XcbeautifyLib",
            dependencies: ["Colorizer"]),
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
