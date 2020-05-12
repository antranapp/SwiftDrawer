// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftDrawer",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftDrawer",
            targets: ["SwiftDrawer"]),
    ],
    targets: [
        .target(
            name: "SwiftDrawer",
            path: "SwiftDrawer/Classes"),
    ]
)
