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

/*代码分析：UserDefaults 扩展，使用 Property Wrapper 简化数据存储
 功能

 这段代码提供了两个 @propertyWrapper 来简化使用 UserDefaults 进行数据存储的操作。

 UserDefaultPropertyWrapper<T>:

 适用于存储基本数据类型 (String, Int, Bool 等) 的 UserDefaults 值。
 使用 key 来标识存储数据的键名。
 提供 wrappedValue 属性用于读写 UserDefaults 中的值。
 UserDefaultWrapper<T: Codable>:

 适用于存储可编码类型 (Codable) 的 UserDefaults 值，例如数组 (Array)、字典 (Dictionary) 或自定义的可编码类型。
 使用 key 来标识存储数据的键名。
 使用 defaultValue 指定默认值，在 UserDefaults 中没有对应键值时使用。
 提供 wrappedValue 属性用于读写 UserDefaults 中的值。
 优点

 简洁: 使用 @propertyWrapper 语法，可以更简洁地声明属性并进行 UserDefaults 的读写操作。
 类型安全: UserDefaultWrapper 限定了存储值的类型，确保类型安全。
 默认值: UserDefaultWrapper 可以设置默认值，避免在 UserDefaults 中找不到对应键值时出现错误。
 
 注意事项

 Error Handling: 目前 UserDefaultWrapper 中的编码和解码错误没有进行处理，可以根据需要进行日志记录或抛出异常。
 Performance: 对于频繁读写大量数据的场景，使用 UserDefaults 可能存在性能瓶颈，建议考虑使用更适合的存储方案。*/


