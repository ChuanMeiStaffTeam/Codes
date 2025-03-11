//
//  AppDelegate.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var launchOptions: [UIApplication.LaunchOptionsKey: Any]?  // 保存启动参数

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 保存启动参数
        self.launchOptions = launchOptions

        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

/*代码分析：AppDelegate.swift

功能概述

该代码文件是 iOS 应用的 AppDelegate 类，是应用的入口点。
主要负责应用启动时的初始化工作，以及处理应用生命周期中的事件。
关键部分

application(_:didFinishLaunchingWithOptions:)
该方法在应用启动完成后被调用。
SHFullscreenPopGesture.configure() 这行代码很可能是为了启用全屏侧滑返回手势。
application(_:configurationForConnecting:)
该方法在创建新的场景会话时被调用，用于配置场景。
application(_:didDiscardSceneSessions:)
该方法在用户丢弃场景会话时被调用，用于释放与丢弃的场景相关的资源。
中文解释

应用委托 (AppDelegate)

是 iOS 应用生命周期中的重要角色。
负责处理应用的启动、运行、进入后台、恢复等事件。
全屏侧滑返回手势

允许用户在应用程序的任何界面通过从屏幕边缘向内滑动来返回上一级界面。
总结

 这段代码主要实现了应用的启动配置，包括启用全屏侧滑返回手势等功能。它体现了 iOS 应用生命周期管理的基本概念。*/
