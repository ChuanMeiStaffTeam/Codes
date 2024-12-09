//
//  NIMManager.swift
//  huanxi
//
//  Created by rslz on 2024/12/9.
//

import Foundation
import NIMSDK

class NIMManager {
    static func register() {
        let option = NIMSDKOption(appKey: "7b801e694e564050c0a8f344094edfba")
        NIMSDK.shared().register(with: option)
    }
}
