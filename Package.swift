// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-observable-user-defaults",
    platforms: [
        .iOS(.v17),
        .macCatalyst(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
    ],
    products: [
        .library(
            name: "ObservableUserDefaults",
            targets: ["ObservableUserDefaults"]
        ),
        .library(
            name: "ObservableUserDefaultsMacros",
            targets: ["ObservableUserDefaultsMacros"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
    ],
    targets: [
        .target(name: "ObservableUserDefaults"),
        .testTarget(
            name: "ObservableUserDefaultsTests",
            dependencies: [
                "ObservableUserDefaults",
                "ObservableUserDefaultsMacros",
            ]
        ),
        .target(
            name: "ObservableUserDefaultsMacros",
            dependencies: [
                "ObservableUserDefaultsMacrosPlugin",
                "ObservableUserDefaults",
            ]
        ),
        .macro(
            name: "ObservableUserDefaultsMacrosPlugin",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "ObservableUserDefaultsMacrosPluginTests",
            dependencies: [
                "ObservableUserDefaultsMacros",
                "ObservableUserDefaultsMacrosPlugin",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
