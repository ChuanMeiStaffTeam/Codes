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

/*这段 Swift 代码定义了一个名为 DataUtil 的工具类，主要用于处理 JSON 数据与其他数据类型之间的转换。这个类提供了一组静态方法，可以方便地在 Data、JSON 字符串、字典和数组之间进行转换。

具体功能如下：

dataToJSONString(data:)： 将 Data 类型的数据（通常是网络请求返回的数据）转换为可读的 JSON 字符串。
dataToDictionary(data:)： 将 Data 类型的数据转换为 Swift 字典类型，以便进一步处理 JSON 数据中的键值对。
dataToArray(data:)： 将 Data 类型的数据转换为 Swift 数组类型，以便处理 JSON 数据中的数组。
jsonStringToData(jsonString:)： 将 JSON 字符串转换为 Data 类型，以便后续进行网络请求或其他操作。
dictionaryToData(dictionary:)： 将 Swift 字典转换为 Data 类型，方便将其作为请求体发送给服务器。
arrayToData(array:)： 将 Swift 数组转换为 Data 类型，方便将其作为请求体发送给服务器。
代码实现原理：

这些方法主要利用了 Swift 内置的 JSONSerialization 类，该类提供了将 JSON 数据与 Swift 对象之间进行转换的功能。

JSONSerialization.jsonObject(with:options:)： 将 Data 类型的 JSON 数据转换为 Swift 对象（字典或数组）。
JSONSerialization.data(withJSONObject:options:)： 将 Swift 对象（字典或数组）转换为 Data 类型的 JSON 数据。
代码的作用：

简化 JSON 数据处理： 提供了一组便捷的方法，方便开发者在项目中处理 JSON 数据。
提高代码可读性： 将 JSON 数据的转换逻辑封装在工具类中，提高了代码的可维护性。
避免重复代码： 避免在多个地方重复编写 JSON 数据转换的代码。
使用场景：

网络请求： 在网络请求中，通常会接收到 JSON 格式的响应数据，可以使用 dataToDictionary 或 dataToArray 方法将数据解析成 Swift 对象。
数据存储： 可以将 Swift 对象转换为 JSON 数据，然后存储到本地或上传到服务器。
数据展示： 可以将 JSON 数据解析成 Swift 对象，然后在 UI 上展示。*/
