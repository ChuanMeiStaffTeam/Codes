//
//  HUDHelper.swift
//  huanxi
//
//  Created by jack on 2024/2/29.
//

import Foundation
import UIKit
import MBProgressHUD

/// Toast 位置枚举
enum ToastPosition {
    case top
    case middle
    case bottom
}

class HUDHelper {
    
    /// 显示加载 HUD
    static func showHUD(in view: UIView? = nil, text: String = "") {
        DispatchQueue.main.async {
            guard let targetView = view ?? getKeyWindow() else { return }
            
            let hud = MBProgressHUD.showAdded(to: targetView, animated: true)
            hud.label.text = text
            hud.mode = .indeterminate
        }
    }
    
    /// 隐藏加载 HUD
    static func hideHUD(in view: UIView? = nil) {
        DispatchQueue.main.async {
            guard let targetView = view ?? getKeyWindow() else { return }
            MBProgressHUD.hide(for: targetView, animated: true)
        }
    }

    /// 显示 Toast 提示
    static func showToast(_ text: String, in view: UIView? = nil, delay: TimeInterval = 2.0, position: ToastPosition = .middle) {
        DispatchQueue.main.async {
            guard let targetView = view ?? getKeyWindow() else { return }
            
            let hud = MBProgressHUD.showAdded(to: targetView, animated: true)
            hud.mode = .text
            hud.label.text = text
            hud.margin = 10
            hud.isUserInteractionEnabled = false

            // 计算偏移量
            let offsetY: CGFloat
            switch position {
            case .top:
                offsetY = -targetView.bounds.height * 0.3
            case .middle:
                offsetY = 0
            case .bottom:
                offsetY = targetView.bounds.height * 0.3
            }

            hud.offset = CGPoint(x: 0, y: offsetY)
            hud.hide(animated: true, afterDelay: delay)
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
