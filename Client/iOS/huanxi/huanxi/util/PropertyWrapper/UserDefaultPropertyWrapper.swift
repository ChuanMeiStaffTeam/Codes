//
//  UserDefaultPropertyWrapper.swift
//  OVTC
//
//  Created by hehuimin on 2024/10/15.
//

import Foundation

@propertyWrapper
public struct UserDefaultPropertyWrapper<T> {
    private var key: String
    private var value: T?
        
    public var wrappedValue: T? {
        get {
            return UserDefaults.standard.value(forKey: key) as? T
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    public init(key: String) {
        self.key = key
    }
}

/// 支持设置默认值
/// 支持 Array、Dictionary 或自定义的 Codable 类型
@propertyWrapper
public struct UserDefaultWrapper<T: Codable> {
    private let key: String
    private let defaultValue: T
    
    public var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return defaultValue
            }
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                return defaultValue
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: key)
            } catch {
                //error
            }
        }
    }
    
    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
