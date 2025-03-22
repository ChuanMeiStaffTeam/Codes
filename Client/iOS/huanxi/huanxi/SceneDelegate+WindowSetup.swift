//
//  SceneDelegate+WindowSetup.swift
//  huanxi
//
//  Created by rslz on 2025/3/14.
//

import UIKit

// MARK: - SceneDelegate Window & Root View Setup
extension SceneDelegate {
    func setupWindowScene(_ scene: UIScene) {
        guard let _ = scene as? UIWindowScene else { return }
    
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
            guard let `self` = self else { return }
            self.window?.makeKeyAndVisible()
            self.window?.rootViewController = tabbar
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                // 初始化全局服务
                appDelegate.setupGlobalServices()
                appDelegate.window = self.window
            }
        } adHandler: {
        }
    }
}
