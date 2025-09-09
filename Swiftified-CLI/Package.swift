// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "Swiftified-CLI",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .executable(name: "Swiftified", targets: ["Swiftified-CLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Mineturtlee/swift-discord", branch: "to-do-resolve")
    ],
    targets: [
        .executableTarget(
            name: "Swiftified-CLI",
            dependencies: [
                .product(name: "Discord", package: "swift-discord")
            ]
        )
    ]
)
