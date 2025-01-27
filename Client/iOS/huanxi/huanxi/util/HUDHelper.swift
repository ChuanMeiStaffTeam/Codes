//
//  HUDHelper.swift
//  huanxi
//
//  Created by jack on 2024/2/29.
//

import Foundation
import UIKit
import MBProgressHUD

class HUDHelper {
    static func showHUD(_ view: UIView?, text: String) {
        DispatchQueue.main.async {
            guard let view = view ?? UIApplication.shared.windows.first(where: \.isKeyWindow) else {
                return
            }

            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = text
            hud.mode = .indeterminate
        }
    }

    static func hideHUD(_ view: UIView?) {
        DispatchQueue.main.async {
            guard let view = view ?? UIApplication.shared.windows.first(where: \.isKeyWindow) else {
                return
            }
            
            MBProgressHUD.hide(for: view, animated: true)
        }
    }

    static func showToast(_ text: String) {
        guard let view = UIApplication.shared.windows.first(where: \.isKeyWindow) else {
            return
        }
        showToast(view, text: text)
    }
    
    static func showToast(_ view: UIView, text: String) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.mode = .text
            hud.label.text = text
            hud.margin = 10
            hud.offset = CGPoint(x: 0, y: 0)
            hud.isUserInteractionEnabled = false
            hud.hide(animated: true, afterDelay: 2.0)
        }
    }
}


/*代码分析：HUDHelper 简化 MBProgressHUD 操作
 功能

 这段代码使用 MBProgressHUD 第三方库封装了常用的 HUD 显示和隐藏功能，并提供了一个显示 Toast 消息的方法。

 showHUD(_:text:): 显示一个进度指示器 (HUD) 并设置文本内容。
 hideHUD(_:): 隐藏指定视图中的 HUD。
 showToast(_:): 在当前 KeyWindow 上显示一个 Toast 消息。
 showToast(_:text:): 在指定视图上显示一个 Toast 消息。
 使用 MBProgressHUD

 MBProgressHUD 是一个常用的 iOS 开发第三方库，可以用来显示进度指示器、提示信息等。
 这段代码封装了 MBProgressHUD 的常用操作，简化了使用过程。
 优点

 封装: 代码封装了 MBProgressHUD 的部分功能，提高了易用性。
 线程安全: 使用 DispatchQueue.main.async 确保在主线程更新 UI。
 灵活性: 提供了针对不同视图的显示和隐藏 HUD 的方法，以及针对 KeyWindow 和指定视图显示 Toast 消息的方法。
 注意事项

 依赖第三方库: 需要引入 MBProgressHUD 库才能使用此功能。
 Toast 样式: 目前 Toast 的样式比较简单，可以根据需求进行定制。
*/
