// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JSONToSwiftV2",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "JSONToSwiftV2",
            targets: ["JSONToSwiftV2"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "JSONToSwiftV2"),
        .testTarget(
            name: "JSONToSwiftV2Tests",
            dependencies: ["JSONToSwiftV2"]
        ),
    ]
)
