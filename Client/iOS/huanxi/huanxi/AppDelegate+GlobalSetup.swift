//
//  AppDelegate+GlobalSetup.swift
//  huanxi
//
//  Created by rslz on 2025/3/14.
//

import Foundation
import AdSupport
import LCDSDK

func JSONConfigPath() -> String! {
    Bundle.main.path(forResource: AdConfigKeys.BUPangrowth_test_config_path, ofType:"json")
}

// MARK: - AppDelegate Global Setup
extension AppDelegate {
    func setupGlobalServices() {
        initializeGlobalServices()
        setupCrashMonitoring()
        setupNetworkMonitoring()
        setupLogger()
    }
    
    /// 初始化全局服务，接收 launchOptions
    private func initializeGlobalServices() {
        debugPrint("✅ 初始化全局服务...")
        // 注册 NIM
        NIMManager.register()
        // 启用FullscreenPopGesture
        SHFullscreenPopGesture.configure()
        // 初始化广告服务
        AdService.shared.initializeSDK {
        }
        // 请求 IDFA 权限
        PermissionService.shared.requestPermission(.idfa) { status in
        }
    }
    
    
    private func setupPangrowthSDK() {
        let config = LCDConfig()
        LCDManager.initialize(withConfigPath: JSONConfigPath(), config:config)
        LCDManager.start(completeHandler: { (initStatus ,userInfo) in
            if initStatus == LCDINITStatus.success {
                print("初始化注册成功！")
            } else {
                print(userInfo["msg"] ?? "")
            }
        })
    }
    
    private func setupCrashMonitoring() {
        debugPrint("Crash Monitoring Initialized")
    }
    
    private func setupNetworkMonitoring() {
        debugPrint("Network Monitoring Initialized")
    }
    
    private func setupLogger() {
        debugPrint("Logger Initialized")
    }
}
