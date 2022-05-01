// swift-tools-version: 5.6

//
//  Package.swift
//  PekaAPI
//
//  Created by Przemysław Ambroży on 09.03.2022.
//  Copyright © 2022 Przemysław Ambroży
//

import PackageDescription

let package = Package(
    name: "PekaAPI",
    platforms: [
        .macOS(.v12), .iOS(.v13), .watchOS(.v6), .tvOS(.v13)
    ],
    products: [
        .library(
            name: "PekaAPI",
            targets: ["PekaAPI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(name: "PekaAPI"),
        .testTarget(
            name: "PekaAPITests",
            dependencies: ["PekaAPI"]
        )
    ]
)
