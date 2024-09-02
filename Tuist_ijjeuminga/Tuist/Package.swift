// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    // Customize the product types for specific package product
    // Default is .staticFramework
    // productTypes: ["Alamofire": .framework,]
    productTypes: [
        "Alamofire": .framework,
        "CoreXLSX": .framework,
        "SkeletonView": .framework,
        "SwiftyJSON": .framework,
        "RxSwift": .framework,
        "RxCocoa": .framework,
    ]
)
#endif

let appName: String = "ijjeuminga"

let package = Package(
    name: appName,
    platforms: [.iOS(.v16)],
    products: [.library(name: appName, targets: [appName])],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.7.0")),
        .package(url: "https://github.com/Alamofire/Alamofire", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/CoreOffice/CoreXLSX", .upToNextMajor(from: "0.14.0")),
        .package(url: "https://github.com/Juanpe/SkeletonView", .upToNextMajor(from: "1.31.0")),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON", .upToNextMajor(from: "5.0.0")),
    ],
    targets: [
        .target(
            name: appName,
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "CoreXLSX", package: "CoreXLSX"),
                .product(name: "SkeletonView", package: "SkeletonView"),
                .product(name: "SwiftyJSON", package: "SwiftyJSON"),
            ]
        )
    ]
)
