//
//  DataUtil.swift
//  huanxi
//
//  Created by jack on 2024/7/24.
//

import Foundation

class DataUtil {
    
    // 将 Data 转换为 JSON 字符串
    static func dataToJSONString(data: Data) -> String? {
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
           let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
    
    // 将 Data 转换为字典
    static func dataToDictionary(data: Data) -> [String: Any]? {
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
           let dictionary = jsonObject as? [String: Any] {
            return dictionary
        }
        return nil
    }
    
    // 将 Data 转换为数组
    static func dataToArray(data: Data) -> [Any]? {
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
           let array = jsonObject as? [Any] {
            return array
        }
        return nil
    }
    
    // 将 JSON 字符串转换为 Data
    static func jsonStringToData(jsonString: String) -> Data? {
        return jsonString.data(using: .utf8)
    }
    
    // 将字典转换为 Data
    static func dictionaryToData(dictionary: [String: Any]) -> Data? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []) {
            return jsonData
        }
        return nil
    }
    
    // 将数组转换为 Data
    static func arrayToData(array: [Any]) -> Data? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: array, options: []) {
            return jsonData
        }
        return nil
    }
}
