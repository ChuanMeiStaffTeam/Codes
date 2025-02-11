//
//  WindowHelper.swift
//  huanxi
//
//  Created by jack on 2024/8/6.
//

import UIKit

class WindowHelper {
    

    /// 获取当前顶部的 UIViewController
    static func topViewController(base: UIViewController? = getKeyWindow()?.rootViewController) -> UIViewController? {
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

/*代码分析：WindowHelper 辅助获取当前窗口和顶层控制器
功能

这段代码提供了两个类方法，用于简化获取当前窗口和顶层视图控制器的操作。

currentWindow(): 返回当前的 UIWindow 对象，该窗口是作为应用程序的 KeyWindow 存在的。
topViewController(base:): 递归遍历视图控制器层次结构，返回当前顶层的 UIViewController 对象。
额外的 getCurrentVC() 方法似乎与现有方法功能重复。

使用方法

Swift

// 获取当前 KeyWindow
if let window = WindowHelper.currentWindow() {
    // 使用 window 对象
}

// 获取当前顶层控制器
let topViewController = WindowHelper.topViewController()
代码优点

封装性: 将获取窗口和顶层控制器的逻辑封装成类方法，易于使用。
可读性: 代码清晰易懂，函数命名和注释清楚地表达了功能。
潜在改进

冗余方法: 可以考虑删除 getCurrentVC() 方法，因为它与 topViewController(base:) 功能相同。
错误处理: 目前没有考虑获取窗口或顶层控制器失败的情况，可以添加适当的错误处理逻辑。
*/
