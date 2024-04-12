// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0


import PackageDescription

let package = Package(
    name: "mimic",
    platforms: [
        .macOS(.v13),
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "mimic",
            targets: ["mimic"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "mimic",
            dependencies: []),
        .testTarget(
            name: "mimicTests",
            dependencies: ["mimic"]),
    ]
)
