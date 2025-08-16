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
            name: "AchievementsSystem"
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
