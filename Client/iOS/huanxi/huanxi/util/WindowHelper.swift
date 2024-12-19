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
    
    // MARK: - --    当前显示window和vc
    static func getCurrentVC() -> UIViewController? {
        var VC = getKeyWindow()?.rootViewController

        if let nav = VC as? UINavigationController {
            VC = nav.children.last
            if let tab = VC as? UITabBarController {
                VC = tab.viewControllers?[tab.selectedIndex]
            }
        } else if let tab = VC as? UITabBarController {
            VC = tab.viewControllers?[tab.selectedIndex]
            if let nav = VC as? UINavigationController {
                VC = nav.children.last
            }
        }
        if let presetVC = VC?.presentedViewController {
            if let nav = presetVC as? UINavigationController {
                VC = nav.children.last
            } else {
                VC = presetVC
            }
        }

        return VC
    }
}
