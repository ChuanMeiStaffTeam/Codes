//
//  CGFloat+LayoutExtension.swift
//  huanxi
//
//  Created by jack on 2024/2/27.
//

import UIKit

extension CGFloat {
    static var statusBarHeight: CGFloat {
        var height: CGFloat = 0.0
        
        if #available(iOS 13.0, *) {
            if let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager {
                height = statusBarManager.statusBarFrame.height
            }
        } else {
            height = UIApplication.shared.statusBarFrame.height
        }
        return height
    }
    
    static var topSafeAreaHeight: CGFloat {
        UIApplication.shared.topSafeAreaHeight
    }
    
    static var bottomSafeAreaHeight: CGFloat {
        UIApplication.shared.bottomSafeAreaHeight
    }
    
    static var navigationBarHeight: CGFloat {
        return 44 // 设置为你的导航栏高度
    }
    
    static var tabBarHeight: CGFloat {
        return 49 // 设置为你的导航栏高度
    }
    
    static var topBarHeight: CGFloat {
        return CGFloat.statusBarHeight + CGFloat.navigationBarHeight
    }
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}

extension UIApplication {
    
    var topSafeAreaHeight: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.statusBarManager?.statusBarFrame.height ?? 0
        }
        return 0
    }
    
    var bottomSafeAreaHeight: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.keyWindow?.safeAreaInsets.bottom ?? 0
        }
        return 0
    }
}
