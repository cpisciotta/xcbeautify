// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "xcbeautify",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        .executable(name: "xcbeautify", targets: ["xcbeautify"]),
        .library(name: "XcbeautifyLib", targets: ["XcbeautifyLib"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.5.0"
        ),
        .package(
            url: "https://github.com/CoreOffice/XMLCoder.git",
            from: "0.17.1"
        ),
    ],
    targets: [
        .executableTarget(
            name: "xcbeautify",
            dependencies: [
                "XcbeautifyLib",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .target(
            name: "XcbeautifyLib",
            dependencies: [
                "XMLCoder",
            ]
        ),
        .testTarget(
            name: "XcbeautifyLibTests",
            dependencies: ["XcbeautifyLib"],
            resources: [
                .process("TestData"),
            ]
        ),
    ]
)

for target in package.targets {
    var settings = target.swiftSettings ?? []
    settings.append(
        contentsOf: [
            .enableUpcomingFeature("StrictConcurrency"),
            .enableUpcomingFeature("InternalImportsByDefault"),
        ]
    )
    target.swiftSettings = settings
}
