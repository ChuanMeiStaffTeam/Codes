//
//  KeychainManager.swift
//  huanxi
//
//  Created by rslz on 2025/2/10.
//

import UIKit

final class KeychainManager {
    static let shared = KeychainManager()

    private let unknownUUID = "00000000000000000000000000000000"

    // 是否同意过隐私协议
    @UserDefaultWrapper<Bool>(key: UserDefaultKeys.isPrivacyAccepted, defaultValue: false)
    var isPrivacyAccepted: Bool
    
    private init() {} // 防止外部实例化

    /// **获取 UUID**
    var uuid: String {
        // 如果用户未同意协议，返回默认 UUID
        guard isPrivacyAccepted else {
            return unknownUUID
        }
        // **1. 从 Keychain 获取**
        if let storedUUID = KeychainHelper.shared.get(KeychainKeys.uuid) {
            return storedUUID
        }
        // **2. 生成新的 UUID，并存储**
        let newUUID = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        KeychainHelper.shared.save(newUUID, forKey: KeychainKeys.uuid)
        return newUUID
    }

    /// **删除 UUID**
    func resetKeychainItem() {
        KeychainHelper.shared.delete(KeychainKeys.uuid)
    }

}
