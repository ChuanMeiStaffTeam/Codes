//
//  Tools.swift
//  huanxi
//
//  Created by rslz on 2024/12/5.
//

import Foundation
import UIKit

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
    
    // 系统分享
    static func systemShareAction(text: String, url: String, img: UIImage, sourceView: UIView) {
        // 要分享的内容
        let textToShare = text
        let urlToShare = URL(string: url)
        let imageToShare = img // 确保图片已添加到项目中

        // 将内容放入一个数组
        let itemsToShare: [Any] = [textToShare, urlToShare as Any, imageToShare as Any]

        // 创建UIActivityViewController
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)

        // 对于iPad设备，需要指定一个弹出位置
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = CGRect(x: sourceView.bounds.midX, y: sourceView.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        if let vc = getKeyWindow()?.rootViewController {
            vc.present(activityViewController, animated: true, completion: nil)
        }
    }
}
