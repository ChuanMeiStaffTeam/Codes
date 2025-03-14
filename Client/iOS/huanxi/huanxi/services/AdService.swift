//
//  AdService.swift
//  huanxi
//
//  Created by rslz on 2025/3/14.
//

import Foundation
import AdSupport
import BUAdSDK

class AdService: NSObject {
    static let shared = AdService()
    
    private var isSDKInitialized = false
    private var initializationCompletion: (() -> Void)?
    
    private var splashAd: BUSplashAd?
    
    private override init() {}
    
    // 初始化穿山甲 SDK
    func initializeSDK(completion: (() -> Void)? = nil) {
        guard !isSDKInitialized else {
            completion?()
            return
        }
        let configuration = BUAdSDKConfiguration()
        
//        // 提前导入配置
//        configuration.mediation.advanceSDKConfigPath = [[NSBundle mainBundle]pathForResource:@"GroMore-config-ios-5000546" ofType:@"json"];
        // 设置APPID
        configuration.appID = AdConfigKeys.BUAdAppID_Test
        configuration.appLogoImage = UIImage(resource: .iconLogo)
        // 设置日志输出
        configuration.debugLog = NSNumber(integerLiteral: 1)
        
        // 如果使用聚合维度功能，则务必将以下字段设置为YES
        // 并检查工程有引用CSJMediation.framework，这样SDK初始化时将启动聚合相关必要组件
        configuration.useMediation = true
        // 隐私合规配置
        // 是否限制个性化广告
        configuration.mediation.limitPersonalAds = NSNumber(integerLiteral: 0)
        // 是否限制程序化广告
        configuration.mediation.limitProgrammaticAds = NSNumber(integerLiteral: 0)
        // 是否禁止CAID
        configuration.mediation.forbiddenCAID = NSNumber(integerLiteral: 0)
        // 主题模式
        configuration.themeStatus = NSNumber(integerLiteral: 1)

        
        BUAdSDKManager.start(asyncCompletionHandler: { [weak self] success, error in
            guard let `self` = self else { return }
            self.isSDKInitialized = true
            debugPrint("穿山甲广告 SDK 初始化成功")
            
            // 执行回调
            completion?()
            self.initializationCompletion?()
        })
    }
    
    // 加载开屏广告
    func loadSplashAd(for window: UIWindow?) {
        guard isSDKInitialized else {
            debugPrint("穿山甲广告 SDK 未初始化，等待初始化完成后加载开屏广告...")
            initializationCompletion = { [weak self] in
                self?.loadSplashAd(for: window)
            }
            return
        }
        
        guard window != nil else { return }
        
        let ad = BUSplashAd(slotID: AdConfigKeys.BUAd_Splash_Test_ID, adSize: CGSize.zero)
        ad.supportCardView = true
        ad.supportZoomOutView = true
        
        ad.delegate = self
        ad.cardDelegate = self
        ad.zoomOutDelegate = self
        ad.tolerateTimeout = 3
        
        splashAd = ad
        splashAd?.loadData()
    }
}

// MARK: - BUMSplashAdDelegate BUSplashCardDelegate BUSplashZoomOutDelegate
extension AdService: BUSplashAdDelegate, BUSplashCardDelegate, BUSplashZoomOutDelegate {
    
    // 加载成功
    func splashAdLoadSuccess(_ splashAd: BUSplashAd) {
        // 使用应用keyWindow的rootViewController（接入简单，推荐）
        if let vc = getKeyWindow()?.rootViewController {
            splashAd.showSplashView(inRootViewController: vc)
        }
    }
    
    // 加载失败
    func splashAdLoadFail(_ splashAd: BUSplashAd, error: BUAdError?) {
        debugPrint("加载失败")
    }

    // 广告即将展示
    func splashAdWillShow(_ splashAd: BUSplashAd) {
        debugPrint("广告即将展示")
    }

    // 广告被点击
    func splashAdDidClick(_ splashAd: BUSplashAd) {
        debugPrint("广告被点击")
    }

    // 广告被关闭
    func splashAdDidClose(_ splashAd: BUSplashAd, closeType: BUSplashAdCloseType) {
        // 按照实际情况决定是否销毁广告对象
        splashAd.mediation?.destoryAd()
    }

    // 广告展示失败
    func splashAdDidShowFailed(_ splashAd: BUSplashAd, error: Error) {
        debugPrint("广告展示失败")
    }

    // 广告渲染完成
    func splashAdRenderSuccess(_ splashAd: BUSplashAd) {
        debugPrint("广告渲染完成")
    }

    // 广告渲染失败
    func splashAdRenderFail(_ splashAd: BUSplashAd, error: BUAdError?) {
        debugPrint("广告渲染失败")
    }

    // 广告展示
    func splashAdDidShow(_ splashAd: BUSplashAd) {
        debugPrint("广告展示")
    }

    // 广告控制器被关闭
    func splashAdViewControllerDidClose(_ splashAd: BUSplashAd) {
        debugPrint("广告控制器被关闭")
    }

    // 其他控制器被关闭
    func splashDidCloseOtherController(_ splashAd: BUSplashAd, interactionType: BUInteractionType) {
        debugPrint("其他控制器被关闭")
    }

    // 视频播放完成
    func splashVideoAdDidPlayFinish(_ splashAd: BUSplashAd, didFailWithError error: (any Error)?) {
        debugPrint("视频播放完成")
    }
    
    func splashCardReady(toShow splashAd: BUSplashAd) {
        if let vc = getKeyWindow()?.rootViewController {
            splashAd.showCardView(inRootViewController: vc)
        }
    }
    
    func splashCardViewDidClick(_ splashAd: BUSplashAd) {
        
    }
    
    func splashCardViewDidClose(_ splashAd: BUSplashAd) {
        // 按照实际情况决定是否销毁广告对象
        splashAd.mediation?.destoryAd()
    }
    
    func splashZoomOutReady(toShow splashAd: BUSplashAd) {
        if let vc = getKeyWindow()?.rootViewController {
            splashAd.showZoomOutView(inRootViewController: vc)
        }
    }
    
    func splashZoomOutViewDidClick(_ splashAd: BUSplashAd) {
        
    }
    
    func splashZoomOutViewDidClose(_ splashAd: BUSplashAd) {
        // 按照实际情况决定是否销毁广告对象
        splashAd.mediation?.destoryAd()
    }
}
