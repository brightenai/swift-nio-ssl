// swift-tools-version:5.2
//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftNIO open source project
//
// Copyright (c) 2017-2018 Apple Inc. and the SwiftNIO project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftNIO project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import PackageDescription

// This package contains a vendored copy of BoringSSL. For ease of tracking
// down problems with the copy of BoringSSL in use, we include a copy of the
// commit hash of the revision of BoringSSL included in the given release.
// This is also reproduced in a file called hash.txt in the
// Sources/CNIOBoringSSL directory. The source repository is at
// https://boringssl.googlesource.com/boringssl.
//
// BoringSSL Commit: 54858b63c1d886f6c8d903d4a4f594f1485de189

let package = Package(
    name: "swift-nio-ssl",
    products: [
        .library(name: "NIOSSL", targets: ["NIOSSL"]),
    ],
    
    dependencies: [
        .package(name:"swift-nio", url: "https://github.com/brightenai/swift-nio.git", .branch("master")),//from: "2.15.0"),
        .package(name:"swift-log",url: "https://github.com/brightenai/swift-log.git",  .branch("master")),
    ],
    targets: [
        .target(name: "CNIOBoringSSL",
                exclude:[
                    "include/boringssl_prefix_symbols_nasm.inc",
                    "hash.txt"
                ],
                cSettings: [
                .unsafeFlags(
                 [
                 "-I",
                 "/usr/local/brightenPlat"
                 ],.when(platforms: [.android]))
                ]
        ),
        .target(name: "CNIOBoringSSLShims", dependencies: ["CNIOBoringSSL"]),
        .target(name: "NIOSSL",
                dependencies: [.product(name: "NIO", package: "swift-nio"),
                               .product(name: "NIOConcurrencyHelpers", package: "swift-nio"), "CNIOBoringSSL", "CNIOBoringSSLShims",
                               .product(name: "Logging", package: "swift-log"),
                               .product(name: "NIOTLS", package: "swift-nio")]
//                linkerSettings: [
//                                .unsafeFlags([ "-Xlinker","-soname=libNIOSSL.so"],.when(platforms: [.android])),
//                                 ]

        )
//        .target(name: "NIOTLSServer", dependencies: ["NIO", "NIOSSL", "NIOConcurrencyHelpers"]),
//        .target(name: "NIOSSLHTTP1Client", dependencies: ["NIO", "NIOHTTP1", "NIOSSL", "NIOFoundationCompat"]),
//        .target(name: "NIOSSLPerformanceTester", dependencies: ["NIO", "NIOSSL"]),
//        .testTarget(name: "NIOSSLTests", dependencies: ["NIOTLS", "NIOSSL"]),
    ],
    cxxLanguageStandard: .cxx11
)
