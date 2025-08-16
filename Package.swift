// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "AchievementsSystem",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "AchievementsSystem",
            targets: ["AchievementsSystem"]
        ),
    ],
    targets: [
        .target(
            name: "AchievementsSystem",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
                .unsafeFlags([
                    "-Xfrontend", "-warn-concurrency",
                    "-Xfrontend", "-enable-actor-data-race-checks"
                ])
            ]
        ),
        .testTarget(
            name: "AchievementsSystemTests",
            dependencies: ["AchievementsSystem"],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
    ]
)
