// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "NavigationLayer",
    products: [
        .library(
            name: "NavigationLayer",
            targets: ["NavigationLayer"]
        ),
    ],
    targets: [
        .target(
            name: "NavigationLayer"
        )
    ],
    swiftLanguageModes: [.v6]
)
