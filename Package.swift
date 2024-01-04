// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AespaBracketedCamera",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "AespaBracketedCamera",
            targets: ["AespaBracketedCamera"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AespaBracketedCamera",
            dependencies: [])
    ]
)
