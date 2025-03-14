//
//  SceneDelegate+ThirdPartySetup.swift
//  huanxi
//
//  Created by rslz on 2025/3/14.
//

import Foundation

// MARK: - SceneDelegate Third-Party Service Setup
extension SceneDelegate {
    func setupThirdPartyServices() {
        setupAdService()
        setupAnalytics()
    }
    
    private func setupAdService() {
        // 初始化成功后加载开屏广告
        AdService.shared.initializeSDK {
            DispatchQueue.main.async {
                AdService.shared.loadSplashAd(for: self.window)
            }
        }
    }
    
    private func setupAnalytics() {
        debugPrint("Analytics Service Initialized")
    }
}
