//
//  Codable+Extension.swift
//  huanxi
//
//  Created by rslz on 2024/11/11.
//

import Foundation


extension Encodable {
    
    /// 将符合 `Codable` 协议的对象转换为字典
    func toJSON() -> [String: Any]? {
        do {
            // 使用 JSONEncoder 将对象编码为 JSON 数据
            let jsonData = try JSONEncoder().encode(self)
            // 使用 JSONSerialization 将 JSON 数据转换为字典
            let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: .fragmentsAllowed) as? [String: Any]
            return dictionary
        } catch {
            print("Failed to convert model to dictionary: \(error)")
            return nil
        }
    }
}

extension Decodable {
    
    /// 将可选字典转换为指定类型的 `Decodable` 对象
    static func from(dictionary: [String: Any]?) -> Self? {
        // 检查 dictionary 是否为空
        guard let dictionary = dictionary else { return nil }
        
        do {
            // 将字典转换为 JSON 数据
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            // 使用 JSONDecoder 解码 JSON 数据
            let model = try JSONDecoder().decode(Self.self, from: jsonData)
            return model
        } catch {
            print("Failed to convert dictionary to model: \(error)")
            return nil
        }
    }
}
