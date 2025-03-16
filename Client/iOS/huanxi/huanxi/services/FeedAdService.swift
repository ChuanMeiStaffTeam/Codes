//
//  FeedAdService.swift
//  huanxi
//
//  Created by rslz on 2025/3/16.
//

import BUAdSDK

class FeedAdService: NSObject {    
    private var adManager: BUNativeAdsManager?
    var onAdsLoaded: (([BUNativeAd]) -> Void)? // 广告加载完成回调
    
    override init() {}

    // 加载信息流广告（确保 SDK 已初始化）
    func loadNativeAds(completion: (([BUNativeAd]) -> Void)? = nil) {
        onAdsLoaded = completion
        let slot = BUAdSlot()
        slot.id = AdConfigKeys.BUAd_Build_Test_ID
        slot.adSize = CGSize(width: UIDevice.screenWidth, height: 300)
        slot.mediation.mutedIfCan = false
        
        let adManager = BUNativeAdsManager(slot: slot)
        adManager.delegate = self
        self.adManager = adManager
        
        adManager.loadAdData(withCount: 3) // 请求 3 个广告
    }
}

// MARK: - BUMNativeAdsManagerDelegate
extension FeedAdService: BUNativeAdsManagerDelegate {
    
    func nativeAdsManagerSuccess(toLoad adsManager: BUNativeAdsManager, nativeAds nativeAdDataArray: [BUNativeAd]?) {
        guard let ads = nativeAdDataArray else { return }
        onAdsLoaded?(ads) // 触发广告加载完成的回调
    }
    
    func nativeAdsManager(_ adsManager: BUNativeAdsManager, didFailWithError error: Error?) {
        debugPrint("信息流广告加载失败: \(error?.localizedDescription ?? "未知错误")")
    }
}
