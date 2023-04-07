// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WidgetsKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v12),
        .watchOS(.v8)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "WidgetsKit",
            targets: ["WidgetsKit"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/exyte/ActivityIndicatorView.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/divadretlaw/EmojiText", .upToNextMajor(from: "2.6.0")),
        .package(name: "PixelfedKit", path: "../PixelfedKit"),
        .package(name: "ClientKit", path: "../ClientKit"),
        .package(name: "ServicesKit", path: "../ServicesKit"),
        .package(name: "EnvironmentKit", path: "../EnvironmentKit")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WidgetsKit",
            dependencies: ["ActivityIndicatorView", "EmojiText", "PixelfedKit", "ClientKit", "ServicesKit", "EnvironmentKit"]),
        .testTarget(
            name: "WidgetsKitTests",
            dependencies: ["WidgetsKit"])
    ]
)
