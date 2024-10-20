//
//  WindowHelper.swift
//  huanxi
//
//  Created by jack on 2024/8/6.
//

import UIKit

class WindowHelper {
    
    /// 获取当前的 UIWindow
    static func currentWindow() -> UIWindow? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    }
    
    /// 获取当前顶部的 UIViewController
    static func topViewController(base: UIViewController? = WindowHelper.currentWindow()?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}
