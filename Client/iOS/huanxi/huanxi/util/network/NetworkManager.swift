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
    private let baseURL = "HTTP://139.196.232.242:8181/api/" // 公共的host
    
    private init() {}
    
    // 公共的请求处理方法
    private func request<T: Codable>(
        urlStr: String,
        method: HTTPMethod,
        parameters: [String: Any]?,
        headers: HTTPHeaders?,
        responseType: T.Type,
        completion: @escaping (Bool, String, T?) -> Void) {
        guard let url = URL(string: "\(baseURL)\(urlStr)") else {
            completion(false, "URL无效", nil)
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
            
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: allHeaders).responseDecodable(of: ResponseModel<T>.self) { response in
            if let data = response.data {
                let jsonDic = DataUtil.dataToDictionary(data: data)
                let jsonStr = DataUtil.dataToJSONString(data: data)
                print(jsonStr)
            }
            switch response.result {
            case .success(let responseModel):
                if responseModel.code == 200 {
                    completion(true, responseModel.message, responseModel.data)
                }else if responseModel.code == 404 || responseModel.code == 402 {
                    LoginManager.removeToken()
                    let topVC = WindowHelper.topViewController()
                    if !((topVC?.isKind(of: LoginViewController.self)) != nil) {
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        topVC?.present(loginVC, animated: true)
                    }
                    
                    completion(false, responseModel.message, responseModel.data)
                } else {
                    completion(false, responseModel.message, responseModel.data)
                }
            case .failure(let error):
                completion(false, error.localizedDescription, nil)
            }
        }
    }
    
    
    // GET request
    func getRequest<T: Codable>(
        urlStr: String,
        parameters: [String: Any]?,
        headers: HTTPHeaders? = nil,
        responseType: T.Type,
        completion: @escaping (Bool, String, T?) -> Void) {
        request(urlStr: urlStr,
                method: .get,
                parameters: parameters,
                headers: headers,
                responseType: responseType,
                completion: completion)
    }
    
    // POST request
    func postRequest<T: Codable>(
        urlStr: String,
        parameters: [String: Any]?,
        headers: HTTPHeaders? = nil,
        responseType: T.Type,
        completion: @escaping (Bool, String, T?) -> Void) {
        request(urlStr: urlStr,
                method: .post,
                parameters: parameters,
                headers: headers,
                responseType: responseType,
                completion: completion)
    }
    
    // DELETE request
    func deleteRequest<T: Codable>(
        urlStr: String,
        parameters: [String: Any]?,
        headers: HTTPHeaders? = nil,
        responseType: T.Type,
        completion: @escaping (Bool, String, T?) -> Void) {
        request(urlStr: urlStr,
                method: .delete,
                parameters: parameters,
                headers: headers,
                responseType: responseType,
                completion: completion)
    }
    
    func uploadSingleImage<T: Codable>(urlStr: String, parameters: [String: Any], image: UIImage, imageName: String = "file", responseType: T.Type, completion: @escaping (Bool, String, T?) -> Void) {
//        let url = "https://yourapi.com/\(urlStr)"
        guard let url = URL(string: "\(baseURL)\(urlStr)") else {
            completion(false, "URL无效", nil)
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
    
    func uploadMultipleImages<T: Codable>(urlStr: String, parameters: [String: Any], images: [UIImage], imageName: String = "images", responseType: T.Type, completion: @escaping (Bool, String, T?) -> Void) {
    //        let url = "https://yourapi.com/\(urlStr)"
            guard let url = URL(string: "\(baseURL)\(urlStr)") else {
                completion(false, "URL无效", nil)
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
                    
//                    if let originalImage = UIImage(named: "yourImageName"),
//                       let imageData = compressImage(image: image, toMB: 1) {
//                        // 使用compressedImage
//                    }
                    
                    if let imageData = self.compressImage(image: image, toMB: 1) {
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
    
    func compressImage(image: UIImage, toMB limit: Int) -> Data? {
        let bytes = limit * 1024 * 1024
        var compression: CGFloat = 1.0
        var imageData = image.jpegData(compressionQuality: compression)
        
        while (imageData?.count ?? 0) > bytes && compression > 0 {
            compression -= 0.1
            imageData = image.jpegData(compressionQuality: compression)
        }
        
        guard let compressedData = imageData else { return nil }
        return compressedData
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
