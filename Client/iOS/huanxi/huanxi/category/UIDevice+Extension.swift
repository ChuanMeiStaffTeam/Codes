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
