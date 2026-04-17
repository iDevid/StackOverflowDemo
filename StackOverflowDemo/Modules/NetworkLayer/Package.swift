// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "NetworkLayer",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "NetworkLayer",
            targets: ["NetworkLayer"]
        ),
    ],
    targets: [
        .target(
            name: "NetworkLayer"
        ),
        .testTarget(
            name: "NetworkLayerTests",
            dependencies: ["NetworkLayer"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
