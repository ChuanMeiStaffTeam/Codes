//
//  KeychainHelper.swift
//  huanxi
//
//  Created by rslz on 2025/2/10.
//

import Foundation
import Security

class KeychainHelper {
    // 单例
    static let shared = KeychainHelper()
    private init() {}

    // 本地缓存，减少 Keychain 访问次数
    private var cache: [String: String] = [:]
    private let queue = DispatchQueue(label: "com.app.keychainHelper", attributes: .concurrent)

    // MARK: - 存储数据
    func save(_ value: String, forKey key: String) {
        let data = value.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        queue.async(flags: .barrier) {
            // 先删除再添加，避免重复存储
            SecItemDelete(query as CFDictionary)
            let status = SecItemAdd(query as CFDictionary, nil)

            if status == errSecSuccess {
                self.cache[key] = value
            } else {
                print("🔴 Keychain 保存失败: \(status)")
            }
        }
    }

    // MARK: - 获取数据
    func get(_ key: String) -> String? {
        // 先检查缓存
        if let cachedValue = cache[key] {
            return cachedValue
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess {
            if let data = dataTypeRef as? Data, let value = String(data: data, encoding: .utf8) {
                cache[key] = value // 存入缓存
                return value
            }
        } else if status != errSecItemNotFound {
            print("🔴 Keychain 读取失败: \(status)")
        }

        return nil
    }

    // MARK: - 删除数据
    func delete(_ key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        queue.async(flags: .barrier) {
            let status = SecItemDelete(query as CFDictionary)

            if status == errSecSuccess || status == errSecItemNotFound {
                self.cache.removeValue(forKey: key)
            } else {
                print("🔴 Keychain 删除失败: \(status)")
            }
        }
    }

    // MARK: - 更新数据
    func update(_ value: String, forKey key: String) {
        let data = value.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]

        queue.async(flags: .barrier) {
            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

            if status == errSecSuccess {
                self.cache[key] = value
            } else if status == errSecItemNotFound {
                self.save(value, forKey: key)
            } else {
                print("🔴 Keychain 更新失败: \(status)")
            }
        }
    }
}
