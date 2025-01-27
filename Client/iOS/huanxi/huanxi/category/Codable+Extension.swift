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

/*代码分析：Codable 扩展，简化 JSON 与模型的转换
 这段代码为 Encodable 和 Decodable 协议提供了两个扩展方法，使得在 Swift 中进行 JSON 与模型之间的转换变得更加便捷。

 核心功能：

 Encodable.toJSON():
 将符合 Encodable 协议的任意对象（如结构体、类）编码成 JSON 数据，并将其转换为字典格式返回。
 首先使用 JSONEncoder 将对象编码成 JSON 数据。
 然后使用 JSONSerialization 将 JSON 数据解析成字典。
 Decodable.from(dictionary:):
 将一个字典转换为指定类型的 Decodable 对象。
 首先将字典转换为 JSON 数据。
 然后使用 JSONDecoder 将 JSON 数据解码成目标类型的对象。
 优势：

 简化编码解码: 避免了手动编写编码解码逻辑。
 通用性强: 适用于任何符合 Encodable 和 Decodable 协议的类型。
 错误处理: 提供了错误处理机制，可以在转换失败时打印错误信息。
 使用场景：

 模型与 JSON 的相互转换: 在网络请求、数据存储等场景中，频繁需要将模型对象与 JSON 数据进行转换。
 自定义 JSON 序列化: 可以通过实现自定义的 Encoder 和 Decoder 来实现更复杂的编码解码逻辑。
 
 注意事项：

 性能: 频繁的 JSON 编码解码可能会影响性能，尤其是在处理大量数据时。
 自定义编码解码: 对于复杂的编码解码需求，可能需要自定义 Encoder 和 Decoder。
 错误处理: 在实际应用中，需要对错误进行更详细的处理，比如显示友好的错误信息。*/
