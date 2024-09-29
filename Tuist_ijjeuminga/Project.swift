import ProjectDescription

enum SettingType {
    case app
    case appExtension
    
    var pathName: String {
        switch self {
        case .app:
            return "Ijjeuminga"
        case .appExtension:
            return "WidgetExtension" // TODO: [] "\(appName)\(extensionName)" 형식으로 바꾸기
        }
    }
}


private let appName: String = "Ijjeuminga"
private let bundleId: String = "com.ijjeuminga.Ijjeuminga"
private let appVersion: String = "1.0.0"
private let bundleVersion: String = "1"
private let deploymentTarget: DeploymentTargets = .iOS("17.0")

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
        "fetch",
        "background-processing"
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
    "CFBundleDisplayName": "이쯤인가", // Config에 분기처리
    "NSSupportsLiveActivities": true,
]


let project = Project(
    name: appName,
    targets: [
        .target(
            name: appName,
            destinations: .iOS,
            product: .app,
            bundleId: bundleId,
//            deploymentTargets: .iOS("16.0"),
            deploymentTargets: deploymentTarget,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["App/Sources/**"],
            resources: ["App/Resources/**"],
            dependencies: [
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "Alamofire"),
                .external(name: "CoreXLSX"),
                .external(name: "SwiftyJSON"),
                .external(name: "SkeletonView"),
                .target(name: "Common"),
                .target(name: "WidgetExtension"),
            ],
            settings: configureSettings(with: .app)
        ),
        .target(
            name: "WidgetExtension",
            destinations: .iOS,
            product: .appExtension,
            bundleId: bundleId + ".WidgetExtension",
            deploymentTargets: deploymentTarget,
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "$(PRODUCT_NAME)",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.widgetkit-extension"
                ],
            ]),
            sources: "WidgetExtension/Sources/**",
            resources: "WidgetExtension/Resources/**",
            dependencies: [
                .target(name: "Common")
            ],
            settings: configureSettings(with: .appExtension)
        ),
        .target(
            name: "Common", // 공통으로 사용해야할 코드가 있을 경우 여기에 코드 분리
            destinations: .iOS,
            product: .framework,
            productName: "Common",
            bundleId: bundleId + ".Common",
            deploymentTargets: deploymentTarget,
            sources: "Common/Sources/**",
            resources: "Common/Resources/**"
        ),
        .target(
            name: "IjjeumingaTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId)Tests",
            infoPlist: .default,
            sources: ["App/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Ijjeuminga")]
        ),
    ],
    additionalFiles: ["README.md"],
    resourceSynthesizers: [
        .assets(),
        .fonts()
    ]
)

private func configureSettings(with settingType: SettingType) -> Settings {
    .settings(
        base: [
            "DEVELOPMENT_TEAM": "R4G74AF442", // MARK: - 공통으로 사용할 team 계정 넣기
            "SERVER_HOST": "http://ws.bus.go.kr",
            "MARKETING_VERSION": "\(appVersion)",
            "CURRENT_PROJECT_VERSION": "\(bundleVersion)"
        ],
        configurations: makeConfigurations(with: settingType),
        defaultSettings: .recommended
    )
}

private func makeConfigurations(with settingType: SettingType) -> [Configuration] {
    let debug: Configuration = .debug(
        name: "Debug",
        xcconfig: .path("Configs/\(settingType.pathName)/\(settingType.pathName)-Debug.xcconfig")
    )
    let release: Configuration = .release(
        name: "Release",
        xcconfig: "Configs/\(settingType.pathName)/\(settingType.pathName)-Release.xcconfig"
    )
    
    return [debug, release]
}



