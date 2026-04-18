// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "PersistenceLayer",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "PersistenceLayer",
            targets: ["PersistenceLayer"]
        ),
    ],
    targets: [
        .target(
            name: "PersistenceLayer",
            resources: [.process("Schema.xcdatamodeld")]
        ),
    ],
    swiftLanguageModes: [.v6]
)
