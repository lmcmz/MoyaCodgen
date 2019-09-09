// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoyaCodgen",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.13.1"),
        .package(url: "https://github.com/kylef/Commander.git", from: "0.0.9"),
//        .package(url: "https://github.com/tuist/xcodeproj.git", .upToNextMajor(from: "6.6.0")),
        .package(url: "https://github.com/tomlokhorst/XcodeEdit.git", .upToNextMajor(from: "2.7.3")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "MoyaCodgen",
            dependencies: [ "Stencil", "XcodeEdit", "Commander"]),
        .testTarget(
            name: "MoyaCodgenTests",
            dependencies: ["MoyaCodgen"]),
    ]
)
