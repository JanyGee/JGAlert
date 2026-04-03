// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "JGAlert",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "JGAlert",
            targets: ["JGAlert"]
        )
    ],
    targets: [
        .target(
            name: "JGAlert",
            path: "Source"
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
