//
//  NetworkManager.swift
//  huanxi
//
//  Created by jack on 2024/2/27.
//

import Alamofire

enum NetworkError: Error {
    case invalidResponse
    case invalidData
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private let domain = ""
    
    private init() {}
    
    func requestData<T: Decodable>(url: URL, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        
        AF.request(url, method: method, parameters: parameters, headers: headers).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                // 在这里处理解码后的对象 'data'
                print(data)
            case .failure(let error):
                // 处理请求失败的情况
                print(error)
            }
        }
    }
}
