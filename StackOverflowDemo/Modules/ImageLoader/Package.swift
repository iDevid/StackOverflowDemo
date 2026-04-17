// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "ImageLoader",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "ImageLoader",
            targets: ["ImageLoader"]
        ),
    ],
    targets: [
        .target(
            name: "ImageLoader"
        ),
    ],
    swiftLanguageModes: [.v6]
)
