// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode2024",
    platforms: [.macOS(.v15)],
    products: [
        .executable(
            name: "adventofcode",
            targets: ["AdventOfCode"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", "1.5.0"..<"1.6.0"),
        .package(url: "https://github.com/pointfreeco/swift-parsing.git", "0.13.0"..<"0.14.0"),
        .package(url: "https://github.com/apple/swift-algorithms.git", "1.2.0"..<"1.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "AdventOfCode",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Day1",
                "Day2",
                "Day3",
                "Day4",
            ]),
        .target(
            name: "Day1",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Parsing", package: "swift-parsing"),
            ]),
        .target(
            name: "Day2",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Parsing", package: "swift-parsing"),
                .product(name: "Algorithms", package: "swift-algorithms"),
            ]),
        .target(
            name: "Day3",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .target(
            name: "Day4",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
    ],
    swiftLanguageModes: [.v6]
)
