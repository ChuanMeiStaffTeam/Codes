//
//  Keys.swift
//  huanxi
//
//  Created by rslz on 2025/2/10.
//

struct UserDefaultKeys {
    /// 首页推荐模块是否展示
    static let homeNoRecommend = "homeNoRecommend"
    
    /// 是否已接受隐私协议
    static let isPrivacyAccepted = "PrivacyAccepted"
}


struct KeychainKeys {
    /// 设备 UUID
    static let uuid = "UUID"
}

struct AdConfigKeys {
    /// 穿山甲AppID
    static let BUAd_AppID = "5668424"
    static let BUAd_AppID_Test = "5669981"

    /// 穿山甲开屏广告id
    static let BUAd_Splash_ID = "103405436"
    static let BUAd_Splash_Test_ID = "103406461"

    /// 穿山甲信息流广告id
    static let BUAd_Build_ID = "103408949"
    static let BUAd_Build_Test_ID = "103408515"
    
    static let BUPangrowth_test_config_path = "SDK_Setting_5669981"
    static let BUPangrowth_config_path  = "SDK_Setting_5668424"

}
