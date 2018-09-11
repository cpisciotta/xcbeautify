// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "xcbeautify",
    dependencies: [
        .package(url: "https://github.com/nsomar/Guaka.git", from: "0.0.0"),
        .package(url: "https://github.com/nsomar/Swiftline.git", from: "0.0.0"),
    ],
    targets: [
        .target(
            name: "XcbeautifyLib",
            dependencies: ["Guaka", "Swiftline"]),
        .target(
            name: "xcbeautify",
            dependencies: ["XcbeautifyLib"]),
        .testTarget(
            name: "XcbeautifyLibTests",
            dependencies: ["XcbeautifyLib"]),
    ]
)
