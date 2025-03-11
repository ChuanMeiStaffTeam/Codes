//
//  AppDelegate+Sdk.swift
//  huanxi
//
//  Created by rslz on 2025/3/11.
//

import UIKit
import AppTrackingTransparency
import BUAdSDK

extension AppDelegate {
    /// 初始化全局服务，接收 launchOptions
    func initializeGlobalServices(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        debugPrint("✅ 初始化全局服务...")
        
        // 启用
        SHFullscreenPopGesture.configure()
        
        // 注册 NIM
        NIMManager.register()
        
        // 模拟初始化逻辑
        if let options = launchOptions {
            if let url = options[.url] as? URL {
                debugPrint("🔗 处理深度链接: \(url)")
            }
        }
        
        // 例如：FirebaseApp.configure()
        // 例如：Logger.shared.setup()
    }
    
    /// iOS 14适配，申请IDFA权限
    func requestIDFAIfNeeded() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                // do something
            }
        }
    }

    /// 初始化穿山甲SDK
    func setupADSDK(completionHandler: @escaping (Bool) -> Void) {
        let config = BUAdSDKConfiguration()
        config.appID = ConfigKeys.BUAdAppID
        BUAdSDKManager.start(asyncCompletionHandler: { success, error in
            completionHandler(success)
        })
    }
    
}

