// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Spectre-2",
    products: [
        .library(name: "Spectre-2", targets: ["App"]),
    ],
    dependencies: [
        // Vapor packages
        
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgresql.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/vapor/auth.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/vapor/leaf.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/vapor-community/stripe-provider.git", from: "2.2.0"),
        .package(url: "https://github.com/vapor-community/sendgrid-provider.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor-community/Imperial.git", from: "0.7.1")


    ],
    targets: [
        .target(name: "App", dependencies: ["FluentPostgreSQL", "Vapor", "Authentication", "Leaf", "Stripe", "SendGrid", "Imperial"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

