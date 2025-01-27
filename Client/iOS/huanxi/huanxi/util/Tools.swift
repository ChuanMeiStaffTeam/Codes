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

/*Tools.swift 分析
这个叫做 Tools 的 Swift 类提供了两个有用的函数：

fetchIPLocation(completion:): 获取当前 IP 地址的位置信息。
systemShareAction(text:, url:, img:, sourceView:): 使用系统分享功能分享文本、链接和图片。
获取 IP 地址位置信息

该函数使用 URLSession 发起网络请求到 http://ip-api.com/json/?lang=zh-CN 获取 IP 地址的位置信息 (JSON 格式)。
它使用 completion 参数提供异步操作的回调，并通过 Result 类型来表示成功 (success) 或失败 (failure) 的结果。
成功时，包含位置信息的字典数据会通过 completion 传递。
失败时，会通过 completion 传递错误信息。
系统分享功能

该函数封装了系统分享功能，可以分享文本、链接和图片。
它接受四个参数：
text: 要分享的文本内容。
url: 要分享的链接地址 (字符串形式)。
img: 要分享的图片 (UIImage 对象)。
它首先将文本、链接和图片整理成一个数组 itemsToShare。
然后创建一个 UIActivityViewController 对象，并设置分享内容 (activityItems)。
对于 iPad 设备，它会设置弹出分享菜单的位置 (popoverPresentationController)。
最后，通过 present 方法展示分享菜单。
代码优点

封装性: 将网络请求和系统分享功能封装成易于使用的函数。
异步操作: 使用 completion 提供异步操作的回调，提高程序响应速度。
错误处理: 通过 Result 类型处理网络请求的潜在错误。
兼容性: 考虑了 iPad 设备上分享菜单的弹出位置。
潜在改进

网络请求库: 可以考虑使用更强大的网络请求库，例如 Alamofire 或 URLSession with Combine，提供更丰富的功能和更好的错误处理。
缓存: 可以考虑缓存获取到的 IP 位置信息，减少重复的网络请求。
分享内容类型: 目前仅支持文本、链接和图片，可以扩展支持其他类型的分享内容，例如文件、代码片段等。*/
