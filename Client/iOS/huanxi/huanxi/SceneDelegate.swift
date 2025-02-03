//
//  SceneDelegate.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit
// import IQKeyboardManagerSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }

//        IQKeyboardManager.shared.enable = true

        // 自定义导航栏的外观
        let appearance = UINavigationBarAppearance()

        // 设置背景色（例如：系统蓝色）
        appearance.backgroundColor = UIColor.black

        // 去除毛玻璃效果
        appearance.backgroundEffect = nil

        // 可选：设置标题文字颜色和字体
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        // 将自定义的外观应用到导航栏
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        // 全局设置暗黑模式
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .dark
        }

        // Launch配置
        LaunchManager.shared.configLaunchHandler { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.window?.makeKeyAndVisible()
                let tabbar = TabBarController()
                strongSelf.window?.rootViewController = tabbar
                
                NIMManager.register()
            }
        } adHandler: {
        }
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}


/*代码主要功能：

这段代码是一个 iOS 应用程序的 SceneDelegate 类，主要负责管理应用程序的场景（Scene）以及生命周期。SceneDelegate 是 iOS 13 引入的一个新概念，用于取代传统的 AppDelegate，提供了更细粒度的场景管理。

代码详细解析：

导入 UIKit 框架：

import UIKit：导入 UIKit 框架，提供 iOS 应用程序开发所需的各种类和方法。
定义 SceneDelegate 类：

class SceneDelegate: UIResponder, UIWindowSceneDelegate：定义一个名为 SceneDelegate 的类，继承自 UIResponder 和 UIWindowSceneDelegate。
UIResponder：提供响应者链的基础，用于处理用户交互事件。
UIWindowSceneDelegate：提供了一组方法，用于管理场景的生命周期事件。
属性：

var window: UIWindow?：声明了一个可选的 UIWindow 属性，用于表示应用程序的主窗口。
方法：

scene(_:willConnectTo:options:)：
该方法在场景连接时调用，用于配置窗口和设置初始视图控制器。
代码中主要做了以下几件事：
自定义导航栏外观：设置背景颜色、去除毛玻璃效果、设置标题颜色等。
设置暗黑模式：如果设备支持，则设置应用程序为暗黑模式。
启动配置：调用 LaunchManager 配置应用程序的启动状态。
设置根视图控制器：将 TabBarController 设置为窗口的根视图控制器，即应用程序的主界面。
注册 NIM：注册第三方库 NIM，可能用于消息推送或其他功能。
其他方法：
sceneDidDisconnect(_:)：场景断开连接时调用。
sceneDidBecomeActive(_:)：场景变为活跃状态时调用。
sceneWillResignActive(_:)：场景即将变为非活跃状态时调用。
sceneWillEnterForeground(_:)：场景即将进入前台时调用。
sceneDidEnterBackground(_:)：场景进入后台时调用。
代码总结：

 这段代码主要负责应用程序的初始化和场景生命周期的管理。它自定义了导航栏的外观，设置了暗黑模式，配置了应用程序的启动状态，并设置了 TabBarController 作为根视图控制器。此外，它还注册了第三方库 NIM，可能用于消息推送等功能。*/
