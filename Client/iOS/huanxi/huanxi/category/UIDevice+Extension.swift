//
//  UIDevice+Extension.swift
//  huanxi
//
//  Created by rslz on 2024/11/19.
//

import Foundation
import UIKit


//MARK: - 设备尺寸
extension UIDevice {
    private static var windowScene: UIWindowScene? {
        return UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    
    /// 顶部安全区高度
    static var sy_safeDistanceTop: CGFloat {
        guard let window = windowScene?.windows.first else { return 0 }
        return window.safeAreaInsets.top
    }
    
    /// 底部安全区高度
    static var sy_safeDistanceBottom: CGFloat {
        guard let window = windowScene?.windows.first else { return 0 }
        return window.safeAreaInsets.bottom
    }
    
    /// 顶部状态栏高度（包括安全区）
    static var sy_statusBarHeight: CGFloat {
        guard let statusBarManager = windowScene?.statusBarManager else { return 0 }
        return statusBarManager.statusBarFrame.height
    }
    
    /// 导航栏高度
    static var sy_navigationBarHeight: CGFloat {
        return 44.0
    }
    
    /// 状态栏+导航栏的高度
    static var sy_navigationFullHeight: CGFloat {
        return UIDevice.sy_safeDistanceTop + UIDevice.sy_navigationBarHeight
    }
    
    /// 底部tabbar高度
    static var sy_tabBarHeight: CGFloat {
        return 49.0
    }
    
    /// 底部tabbar高度（包括安全区）
    static var sy_tabBarFullHeight: CGFloat {
        return UIDevice.sy_tabBarHeight + UIDevice.sy_safeDistanceBottom
    }
    
    /// 屏幕宽度
    static var screenWidth: CGFloat {
        guard let screen = windowScene?.screen else { return 0 }
        return screen.bounds.width
    }
    
    /// 屏幕高度
    static var screenHeight: CGFloat {
        guard let screen = windowScene?.screen else { return 0 }
        return screen.bounds.height
    }
    
    /// 按宽度375比例
    static func screenWidthScale(_ num: CGFloat) -> CGFloat {
        return (screenWidth / 375.0) * num
    }

    /// 按高度667比例
    static func screenHeightScale(_ num: CGFloat) -> CGFloat {
        return (screenHeight / 667.0) * num
    }

    /// 按宽度比例适配size
    static func screenSizeScale(_ size: CGSize) -> CGSize {
        let width = screenWidthScale(size.width)
        let height = width / size.width * size.height
        return CGSize(width: width, height: height)
    }
    
    /// 比例
    static var scale: CGFloat {
        guard let screen = windowScene?.screen else { return 1 }
        return screen.scale
    }
    
    /// 1像素
    static var onePx: CGFloat {
        return 1 / scale
    }
}


/*代码分析：UIDevice 扩展，获取设备相关尺寸
 这段代码为 UIDevice 类添加了一个扩展，主要用于获取设备屏幕、安全区域、导航栏、标签栏等相关尺寸信息。

 核心功能：

 获取设备屏幕尺寸: screenWidth 和 screenHeight 属性用于获取设备屏幕的宽度和高度。
 获取安全区域高度: sy_safeDistanceTop 和 sy_safeDistanceBottom 用于获取设备顶部和底部的安全区域高度。
 获取系统栏高度: sy_statusBarHeight、sy_navigationBarHeight、sy_tabBarHeight 分别获取状态栏、导航栏和标签栏的高度。
 比例适配: screenWidthScale、screenHeightScale 和 screenSizeScale 方法用于根据设计图的尺寸比例来适配当前设备的屏幕尺寸。
 像素单位: onePx 属性用于获取当前设备的 1 像素所对应的点。
 代码亮点：

 封装性好: 将设备相关的尺寸信息封装成静态属性，方便调用。
 适配性强: 考虑了不同设备的屏幕尺寸和系统版本，特别是适配了 iPhone X 之后的刘海屏。
 实用性高: 提供了常用的尺寸计算方法，如比例适配、像素单位等。
 使用场景：

 自适应布局: 根据设备尺寸和安全区域动态调整 UI 布局。
 图片适配: 根据屏幕尺寸缩放图片。
 自定义控件: 实现自适应大小的自定义控件。
 代码解读：

 windowScene: 获取当前应用的窗口场景，用于获取屏幕、安全区域等信息。
 safeAreaInsets: 获取安全区域的内边距。
 statusBarManager: 获取状态栏管理器，用于获取状态栏的高度。
 **screenWidthScale,screenHeightScale,screenSizeScale`: 根据设计图尺寸比例进行缩放。
 onePx: 获取设备的像素单位，用于精确的像素级布局。
 注意事项：

 系统版本兼容性: 对于较老的 iOS 系统，可能需要做一些兼容性处理。
 动态变化: 如果设备旋转或系统设置发生变化，这些尺寸可能会动态改变。
 自定义导航栏/标签栏: 如果自定义了导航栏或标签栏的高度，需要相应地修改扩展中的常量值。
*/
