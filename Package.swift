// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Aespa",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Aespa",
            targets: ["Aespa"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", .upToNextMinor(from: "1.2.0")),
    ],
    targets: [
        .target(
            name: "Aespa",
            dependencies: [])
    ]
)
