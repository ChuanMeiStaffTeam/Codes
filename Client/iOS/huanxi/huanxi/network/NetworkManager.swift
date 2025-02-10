//
//  NetworkManager.swift
//  huanxi
//
//  Created by jack on 2024/2/27.
//

import Alamofire

import Foundation

// MARK: - ResponseModel
struct ResponseModel<T: Codable>: Codable {
    let code: Int
    let message: String
    let data: T?
}

// MARK: - NetworkManager
class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    // 公共的请求处理方法
    private func request<T: Codable>(
        _ path: String,
        method: HTTPMethod,
        parameters: [String: Any]?,
        headers: HTTPHeaders?,
        responseType: T.Type,
        completion: @escaping (Bool, String, T?) -> Void) {
            
        guard var urlComponents = URLComponents(string: buildURL(path)) else {
            completion(false, "URL无效", nil)
            return
        }
        
        // 如果是 .get 方法，将参数拼接到 URL 上
        if method == .get, let parameters = parameters {
            let queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            completion(false, "URL无效", nil)
            return
        }
            
        logRequest(url.absoluteString, parameters: parameters, headers: headers) // 打印请求日志

        // 设置请求头
        var allHeaders = HTTPHeaders()
        headers?.dictionary.forEach({ (key: String, value: String) in
            let header = HTTPHeader.init(name: key, value: value)
            allHeaders.add(header)
        })
        if let token = LoginManager.shared.getToken() {
        allHeaders.add(name: "token", value: token)
        }
        let uuid = KeychainManager.shared.uuid
        allHeaders.add(name: "deviceId", value: uuid)

        // 使用 .get 请求时，不再传递参数，避免重复
        let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
                
        AF.request(url, method: method, parameters:  method == .get ? nil : parameters, encoding: encoding, headers: allHeaders).responseDecodable(of: ResponseModel<T>.self) { response in
            self.logResponse(response) // 打印响应日志
            switch response.result {
            case .success(let responseModel):
                switch responseModel.code {
                case 200:
                    completion(true, responseModel.message, responseModel.data)
                case 402: //登录过期，登录状态异常
                    LoginManager.shared.logout()
                    Task {
                        _ = await LoginViewController.startLogin()
                    }
                    completion(false, responseModel.message, responseModel.data)
                default:
                    completion(false, responseModel.message, responseModel.data)
                }
            case .failure(let error):
                completion(false, error.localizedDescription, nil)
            }
        }
    }
    
    
    // GET request
    func getRequest<T: Codable>(
        path: String,
        parameters: [String: Any]?,
        headers: HTTPHeaders? = nil,
        responseType: T.Type,
        completion: @escaping (Bool, String, T?) -> Void) {
        request(path,
                method: .get,
                parameters: parameters,
                headers: headers,
                responseType: responseType,
                completion: completion)
    }
    
    // POST request
    func postRequest<T: Codable>(
        path: String,
        parameters: [String: Any]?,
        headers: HTTPHeaders? = nil,
        responseType: T.Type,
        completion: @escaping (Bool, String, T?) -> Void) {
        request(path,
                method: .post,
                parameters: parameters,
                headers: headers,
                responseType: responseType,
                completion: completion)
    }
    
    // DELETE request
    func deleteRequest<T: Codable>(
        path: String,
        parameters: [String: Any]?,
        headers: HTTPHeaders? = nil,
        responseType: T.Type,
        completion: @escaping (Bool, String, T?) -> Void) {
        request(path,
                method: .delete,
                parameters: parameters,
                headers: headers,
                responseType: responseType,
                completion: completion)
    }
    
    func uploadSingleImage<T: Codable>(path: String, parameters: [String: Any], image: UIImage, imageName: String = "file", responseType: T.Type, completion: @escaping (Bool, String, T?) -> Void) {
//        let url = "https://yourapi.com/\(urlStr)"

        guard let url = URL(string: buildURL(path)) else {
            completion(false, "URL无效", nil)
            return
        }
        
        var allHeaders = HTTPHeaders()
        if let token = LoginManager.shared.getToken() {
            allHeaders.add(name: "token", value: token)
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if let data = "\(value)".data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                multipartFormData.append(imageData, withName: imageName, fileName: "\(imageName).jpg", mimeType: "image/jpeg")
            }
        }, to: url, headers: allHeaders).responseDecodable(of: ResponseModel<T>.self) { response in
            switch response.result {
            case .success(let responseModel):
                if responseModel.code == 200 {
                    completion(true, responseModel.message, responseModel.data)
                } else {
                    completion(false, responseModel.message, responseModel.data)
                }
            case .failure(let error):
                completion(false, error.localizedDescription, nil)
            }
        }
    }
    
    func uploadMultipleImages<T: Codable>(path: String, parameters: [String: Any], images: [UIImage], imageName: String = "images", responseType: T.Type, completion: @escaping (Bool, String, T?) -> Void) {
    //        let url = "https://yourapi.com/\(urlStr)"
    
        
            guard let url = URL(string: buildURL(path)) else {
                completion(false, "URL无效", nil)
                return
            }
        
            var allHeaders = HTTPHeaders()
            if let token = LoginManager.shared.getToken() {
                allHeaders.add(name: "token", value: token)
            }
        
            AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                for (index, image) in images.enumerated() {
                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                        multipartFormData.append(imageData, withName: imageName, fileName: "\(imageName)_\(index).jpg", mimeType: "image/jpeg")
                    }
                }
            }, to: url, headers: allHeaders).responseDecodable(of: ResponseModel<T>.self) { response in
                switch response.result {
                case .success(let responseModel):
                    if responseModel.code == 200 {
                        completion(true, responseModel.message, responseModel.data)
                    } else {
                        completion(false, responseModel.message, responseModel.data)
                    }
                case .failure(let error):
                    completion(false, error.localizedDescription, nil)
                }
            }
        }
    
    // MARK: - URL 构建
    private func buildURL(_ path: String) -> String {
        return Api.baseURL + "/api/" + path
    }

    
    // MARK: - 错误处理
    private func handleError(_ error: AFError) {
        print("Network Error: \(error.localizedDescription)")
        // 可以在这里扩展全局错误处理，比如提示用户，处理特定的错误码等
    }
    
    // MARK: - 日志记录（请求）
    private func logRequest(_ url: String, parameters: [String: Any]?, headers: HTTPHeaders?) {
        print("Request URL: \(url)")
        if let params = parameters {
            print("Parameters: \(params)")
        }
        if let headers = headers {
            print("Headers: \(headers)")
        }
    }
    
    // MARK: - 日志记录（响应）
    private func logResponse<T>(_ response: DataResponse<T, AFError>) {
        if let data = response.data {
            let responseString = String(data: data, encoding: .utf8) ?? "No response data"
            print("Response: \(responseString)")
        }
    }

}


/*
struct ResponseModel: Codable {
    let code: Int?
    let data: [String: CodableValue]?
    let message: String
}

enum CodableValue: Codable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case array([CodableValue])
    case dictionary([String: CodableValue])
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode([CodableValue].self) {
            self = .array(value)
        } else if let value = try? container.decode([String: CodableValue].self) {
            self = .dictionary(value)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.typeMismatch(CodableValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown type"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .string(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        case .array(let value):
            try container.encode(value)
        case .dictionary(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
    
    var stringValue: String? {
        if case .string(let value) = self {
            return value
        }
        return nil
    }

    var intValue: Int? {
        if case .int(let value) = self {
            return value
        }
        return nil
    }

    var doubleValue: Double? {
        if case .double(let value) = self {
            return value
        }
        return nil
    }

    var boolValue: Bool? {
        if case .bool(let value) = self {
            return value
        }
        return nil
    }

    var arrayValue: [CodableValue]? {
        if case .array(let value) = self {
            return value
        }
        return nil
    }

    var dictionaryValue: [String: CodableValue]? {
        if case .dictionary(let value) = self {
            return value
        }
        return nil
    }
}

struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let arrayValue = try? container.decode([AnyCodable].self) {
            value = arrayValue.map { $0.value }
        } else if let dictionaryValue = try? container.decode([String: AnyCodable].self) {
            value = dictionaryValue.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "无法解码 Any 类型")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let boolValue = value as? Bool {
            try container.encode(boolValue)
        } else if let intValue = value as? Int {
            try container.encode(intValue)
        } else if let doubleValue = value as? Double {
            try container.encode(doubleValue)
        } else if let stringValue = value as? String {
            try container.encode(stringValue)
        } else if let arrayValue = value as? [Any] {
            try container.encode(arrayValue.map { AnyCodable($0) })
        } else if let dictionaryValue = value as? [String: Any] {
            try container.encode(dictionaryValue.mapValues { AnyCodable($0) })
        } else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "无法编码 Any 类型"))
        }
    }
}



class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "HTTP://139.196.232.242:8080/api/" // 公共的host

    private init() {}

    // 公共的请求处理方法
    private func request(
        urlStr: String,
        method: HTTPMethod,
        parameters: [String: Any]?,
        headers: HTTPHeaders?,
        encoding: ParameterEncoding,
        success: @escaping (ResponseModel?) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)\(urlStr)") else {
            failure(AFError.invalidURL(url: urlStr))
            return
        }
        
        var allHeaders = HTTPHeaders()
        headers?.dictionary.forEach({ (key: String, value: String) in
            let header = HTTPHeader.init(name: key, value: value)
            allHeaders.add(header)
        })
        if let token = LoginManager.getToken() {
            allHeaders.add(name: "token", value: token)
        }

        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: allHeaders).response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    let jsonDic = DataUtil.dataToDictionary(data: data)
                    if jsonDic?["code"] as! Int == 200 {
                        
                    }
                    
                    
                    let jsonStr = DataUtil.dataToJSONString(data: data)
                    print("jsonStr === " + (jsonStr ?? ""))
                    do {
                        let model = try JSONDecoder().decode(ResponseModel.self, from: data)
                        success(model)
                    } catch {
                        failure(error)
                        print("Data to model conversion error: \(error)")
                    }
                } else {
                    failure(AFError.invalidURL(url: urlStr))
                }
            case .failure(let error):
                failure(error)
            }
        }
    }

    // GET request
    func getRequest(
        urlStr: String,
        parameters: [String: Any]?,
        headers: HTTPHeaders? = nil,
        success: @escaping (ResponseModel?) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        request(urlStr: urlStr, method: .get, parameters: parameters, headers: headers, encoding: URLEncoding.default, success: success, failure: failure)
    }

    // POST request
    func postRequest(
        urlStr: String,
        parameters: [String: Any]?,
        headers: HTTPHeaders? = nil,
        success: @escaping (ResponseModel?) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        request(urlStr: urlStr, method: .post, parameters: parameters, headers: headers, encoding: JSONEncoding.default, success: success, failure: failure)
    }

    // POST form-data request
    func postFormDataRequest(
        urlStr: String,
        parameters: [String: Any],
        headers: HTTPHeaders? = nil,
        success: @escaping (ResponseModel?) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)\(urlStr)") else {
            failure(AFError.invalidURL(url: urlStr))
            return
        }

        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if let data = (value as? String)?.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
                // Add other data types as needed
            }
        }, to: url, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    do {
                        let model = try JSONDecoder().decode(ResponseModel.self, from: data)
                        success(model)
                    } catch {
                        failure(error)
                        print("Data to model conversion error: \(error)")
                    }
                } else {
                    failure(AFError.invalidURL(url: urlStr))
                }
            case .failure(let error):
                failure(error)
            }
        }
    }

    // Download file
    func downloadFile(
        urlStr: String,
        destination: URL,
        success: @escaping (URL?) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)\(urlStr)") else {
            failure(AFError.invalidURL(url: urlStr))
            return
        }

        AF.download(url, to: { _, _ in (destination, [.removePreviousFile, .createIntermediateDirectories]) }).response { response in
            switch response.result {
            case .success(let fileURL):
                success(fileURL)
            case .failure(let error):
                failure(error)
            }
        }
    }

    // Upload file
    func uploadFile(
        urlStr: String,
        fileURL: URL,
        headers: HTTPHeaders? = nil,
        success: @escaping (ResponseModel?) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)\(urlStr)") else {
            failure(AFError.invalidURL(url: urlStr))
            return
        }

        AF.upload(fileURL, to: url, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    do {
                        let model = try JSONDecoder().decode(ResponseModel.self, from: data)
                        success(model)
                    } catch {
                        failure(error)
                        print("Data to model conversion error: \(error)")
                    }
                } else {
                    failure(AFError.invalidURL(url: urlStr))
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    func uploadSingleImage(urlStr: String, parameters: [String: Any], image: UIImage, imageName: String = "file", completion: @escaping (ResponseModel?) -> Void, failure: @escaping (Error) -> Void) {
//        let url = "https://yourapi.com/\(urlStr)"
        guard let url = URL(string: "\(baseURL)\(urlStr)") else {
            failure(AFError.invalidURL(url: urlStr))
            return
        }
        
        var allHeaders = HTTPHeaders()
        if let token = LoginManager.getToken() {
            allHeaders.add(name: "token", value: token)
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if let data = "\(value)".data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                multipartFormData.append(imageData, withName: imageName, fileName: "\(imageName).jpg", mimeType: "image/jpeg")
            }
        }, to: url, headers: allHeaders).responseDecodable(of: ResponseModel.self) { response in
            switch response.result {
            case .success(let responseModel):
                completion(responseModel)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func uploadMultipleImages(urlStr: String, parameters: [String: Any], images: [UIImage], imageName: String = "images", completion: @escaping (ResponseModel?) -> Void, failure: @escaping (Error) -> Void) {
//            let url = "https://yourapi.com/\(urlStr)"
            guard let url = URL(string: "\(baseURL)\(urlStr)") else {
                failure(AFError.invalidURL(url: urlStr))
                return
            }
        
            var allHeaders = HTTPHeaders()
            if let token = LoginManager.getToken() {
                allHeaders.add(name: "token", value: token)
            }
        
            AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                for (index, image) in images.enumerated() {
                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                        multipartFormData.append(imageData, withName: imageName, fileName: "\(imageName)_\(index).jpg", mimeType: "image/jpeg")
                    }
                }
            }, to: url, headers: allHeaders).responseDecodable(of: ResponseModel.self) { response in
                switch response.result {
                case .success(let responseModel):
                    completion(responseModel)
                case .failure(let error):
                    failure(error)
                }
            }
        }
}

*/


/*代码主要功能：
 
 这段 Swift 代码定义了一个名为 NetworkManager 的类，这个类是用来管理网络请求的。它提供了一套方法，让开发者可以方便地向服务器发送各种类型的请求，比如 GET、POST、DELETE 等，并处理返回的数据。

 代码结构和主要功能：

 ResponseModel 结构体：

 用来表示服务器返回的数据结构。
 包含三个属性：
 code: HTTP 状态码，用于判断请求是否成功。
 message: 返回的消息，通常包含错误信息或成功提示。
 data: 实际的数据，类型为泛型 T，可以根据需要定义不同的数据模型。
 NetworkManager 类：

 shared 属性： 提供了一个单例实例，方便在整个应用中访问。
 request 方法：
 是核心方法，用于发送网络请求。
 参数：
 path: 请求的路径。
 method: HTTP 方法（GET、POST、PUT、DELETE 等）。
 parameters: 请求参数。
 headers: 请求头。
 responseType: 期望的返回数据类型。
 completion: 请求完成后的回调，包含是否成功、返回消息和数据。
 其他方法：
 getRequest、postRequest、deleteRequest： 分别是 GET、POST、DELETE 请求的封装，简化了调用。
 uploadSingleImage、uploadMultipleImages： 用于上传单个或多个图片。
 工作流程：

 创建 NetworkManager 实例。
 调用 request 或其封装方法，传入请求参数。
 NetworkManager 内部使用 Alamofire 库发送网络请求。
 根据服务器返回的数据，解析成 ResponseModel 结构体。
 调用 completion 回调，将结果返回给调用者。
 关键点：

 错误处理： 代码中对网络请求错误进行了处理，并在 completion 回调中返回错误信息。
 数据解析： 使用 Codable 协议对服务器返回的 JSON 数据进行解析，方便使用。
 日志输出： 打印请求和响应信息，方便调试。
 图片上传： 支持上传单个或多个图片。
 登录状态判断： 在请求中添加 token，并在 token 过期时处理登录逻辑。
 总结：

 这个 NetworkManager 类提供了一个灵活、易用的网络请求框架，可以大大简化 iOS 应用中网络请求的开发。它可以处理各种类型的请求，并提供了良好的错误处理和数据解析机制。*/
