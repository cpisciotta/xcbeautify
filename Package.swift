// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "xcbeautify",
    products: [
        .executable(name: "xcbeautify", targets: ["xcbeautify"]),
        .library(name: "XcbeautifyLib", targets: ["XcbeautifyLib"])
    ],
    dependencies: [
        .package(url: "https://github.com/nsomar/Guaka.git", from: "0.0.0"),
        .package(url: "https://github.com/getGuaka/Colorizer.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "XcbeautifyLib",
            dependencies: ["Guaka", "Colorizer"]),
        .target(
            name: "xcbeautify",
            dependencies: ["XcbeautifyLib"]),
        .testTarget(
            name: "XcbeautifyLibTests",
            dependencies: ["XcbeautifyLib"]),
    ]
)
