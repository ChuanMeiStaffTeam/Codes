//
//  Tools.swift
//  huanxi
//
//  Created by rslz on 2024/12/5.
//

import Foundation

class Tools {
    
    // MARK: - ip定位
    static func fetchIPLocation(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let urlString = "http://ip-api.com/json/?lang=zh-CN"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "IPLocation", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(json))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
