// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftCraftLauncherHelp",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftCraftLauncherHelp",
            targets: ["SwiftCraftLauncherHelp"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftCraftLauncherHelp",
            dependencies: [],
            resources: [
                .copy("Resources/SwiftCraftLauncher.help")
            ]
        ),
    ]
)

