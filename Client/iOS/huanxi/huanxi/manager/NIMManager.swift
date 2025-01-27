//
//  NIMManager.swift
//  huanxi
//
//  Created by rslz on 2024/12/9.
//

import Foundation                           //负责管理 NIMSDK（网易云信 SDK）的注册和初始化。
import NIMSDK                 

class NIMManager {
    static func register() {
        let option = NIMSDKOption(appKey: "7b801e694e564050c0a8f344094edfba")
        NIMSDK.shared().register(with: option)
    }
}
