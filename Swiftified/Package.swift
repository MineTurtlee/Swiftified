// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = Package(
    name: "Swiftified",
    products: [
        .library(name: "Swiftified", targets: ["Swiftified"])
    ],
    dependencies: [
        .package(url: "https://github.com/MineTurtlee/swift-discord.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "Swiftified", dependencies: [
            .product(name: "Discord", package: "swift-discord")
        ])
    ]
)
