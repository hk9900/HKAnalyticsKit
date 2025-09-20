// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HKAnalyticsKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16)
    ],
    products: [
        .library(name: "HKAnalyticsKit", targets: ["HKAnalyticsKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "12.0.0"),
    ],
    targets: [
        .target(
            name: "HKAnalyticsKit",
            dependencies: [
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
            ]
        ),
        .testTarget(
            name: "HKAnalyticsKitTests",
            dependencies: ["HKAnalyticsKit"]
        ),
    ]
)
