//
//  SceneDelegate+ThirdPartySetup.swift
//  huanxi
//
//  Created by rslz on 2025/3/14.
//

import Foundation
import LCDSDK

// MARK: - SceneDelegate Third-Party Service Setup
extension SceneDelegate {
    func setupThirdPartyServices() {
        setupAdService()
        setupAnalytics()
    }
    
    private func setupAdService() {
        // 初始化成功后加载开屏广告
        AdService.shared.initializeSDK { [weak self] in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                AdService.shared.loadSplashAd(for: self.window)
            }
            self.setupPangrowthSDK()
        }
    }
    
    private func setupAnalytics() {
        debugPrint("Analytics Service Initialized")
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
}
