// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ECDHESwiftCLI",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    dependencies: [
        // Use Swift Crypto for cross-platform compatibility
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0")
    ],
    targets: [
        .executableTarget(
            name: "ECDHESwiftCLI",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto")
            ],
            path: "Sources/ECDHESwiftCLI"
        ),
        .testTarget(
            name: "ECDHESwiftCLITests",
            dependencies: ["ECDHESwiftCLI"],
            path: "Tests/ECDHESwiftCLITests"
        ),
    ]
)
