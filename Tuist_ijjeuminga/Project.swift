import ProjectDescription

private let appName: String = "Ijjeuminga"
private let bundleId: String = "com.ijjeuminga.Ijjeuminga"
private let appVersion: String = "1.0.0"
private let bundleVersion: String = "1"

private let infoPlist: [String: Plist.Value] = [
    "UILaunchStoryboardName": "LaunchScreen",
    "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": false,
        "UISceneConfigurations": [
            "UIWindowSceneSessionRoleApplication": [
                [
                    "UISceneConfigurationName": "Default Configuration",
                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
                ]
            ]
        ]
    ],
    "CFBundleShortVersionString": "\(appVersion)",
    "CFBundleVersion": "\(bundleVersion)",
    "UIBackgroundModes": [
        "audio",
        "location",
    ],
    "Fonts provided by application": [
        "Item0": "AppleSDGothicNeo-Bold.otf",
        "Item1": "AppleSDGothicNeo-Medium.otf",
        "Item2": "AppleSDGothicNeo-Regular.otf",
    ],
    "UIUserInterfaceStyle": "Light",
    "SERVER_HOST": "${SERVER_HOST}",
    "NSAppTransportSecurity": [
        "NSAllowsArbitraryLoads": true
    ],
    "NSLocationWhenInUseUsageDescription": "현재 위치를 기반으로 목적지 도착을 알려드리기 위해 권한 승인이 필요합니다.",
    "NSLocationAlwaysAndWhenInUseUsageDescription": "현재 위치를 기반으로 목적지 도착을 알려드리기 위해 권한 승인이 필요합니다.",
    "UISupportedInterfaceOrientations": [
        "UIInterfaceOrientationPortrait"
    ],
    "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
    "CFBundleDisplayName": "${PRODUCT_NAME}" // Config에 분기처리
]


let project = Project(
    name: appName,
    targets: [
        .target(
            name: appName,
            destinations: .iOS,
            product: .app,
            bundleId: bundleId,
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "Alamofire"),
                .external(name: "CoreXLSX"),
                .external(name: "SwiftyJSON"),
                .external(name: "SkeletonView"),
            ],
            settings: configureSettings()
        ),
        .target(
            name: "IjjeumingaTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId)Tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "Ijjeuminga")]
        ),
    ],
    additionalFiles: ["README_md"],
    resourceSynthesizers: [
        .assets(),
        .fonts()
    ]
)

private func configureSettings() -> Settings {
    .settings(
        base: [
            "DEVELOPMENT_TEAM": "R4G74AF442", // MARK: - 공통으로 사용할 team 계정 넣기
            "SERVER_HOST": "http://ws.bus.go.kr",
            "MARKETING_VERSION": "\(appVersion)",
            "CURRENT_PROJECT_VERSION": "\(bundleVersion)"
        ],
        configurations: makeConfigurations(),
        defaultSettings: .recommended
    )
}

private func makeConfigurations() -> [Configuration] {
    let debug: Configuration = .debug(name: "Debug", xcconfig: "Configs/Debug.xcconfig")
    let release: Configuration = .release(name: "Release", xcconfig: "Configs/Release.xcconfig")
    
    return [debug, release]
}
