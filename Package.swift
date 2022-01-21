// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftWithAdamBlog",

    products: [
        .executable(name: "SwiftWithAdamBlog", targets: ["SwiftWithAdamBlog"])
    ],

    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.8.0"),
        .package(name: "SplashPublishPlugin", url: "https://github.com/johnsundell/splashpublishplugin", from: "0.1.0")
    ],

    targets: [
        .executableTarget(
            name: "SwiftWithAdamBlog",
            dependencies: [
                "CodingPublishTheme",
                .product(name: "Publish", package: "Publish"),
                "SplashPublishPlugin"
            ]
        ),
        .target(
            name: "CodingPublishTheme",
            dependencies: [
                .product(name: "Publish", package: "Publish")
            ]
        )
    ]
)
