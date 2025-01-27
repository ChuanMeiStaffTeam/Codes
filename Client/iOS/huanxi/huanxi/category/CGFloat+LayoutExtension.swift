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
            if #available(iOS 15.0, *) {
                return windowScene.keyWindow?.safeAreaInsets.bottom ?? 0
            } else {
                // Fallback on earlier versions
            }
        }
        return 0
    }
}

/*这段代码主要为 UIView 类添加了几个计算属性，使得我们可以更方便地获取和设置视图的 frame 属性。
 
 核心功能：

 简化 frame 的访问和修改：
 直接通过 x, y, width, height, size, origin 等属性来访问和修改视图的坐标和尺寸，而不用每次都写 frame.origin.x 这种冗长的代码。
 提供 bottom 和 right 属性： 方便获取视图的底部和右边的坐标。
 获取父视图控制器： parentViewController 属性可以快速获取当前视图的父视图控制器。
 具体功能：

 parentViewController: 通过遍历响应者链，找到最近的 UIViewController。这在需要访问视图控制器的方法或属性时非常有用，比如展示弹窗、修改导航栏等。
 x, y, width, height, size, origin: 这些属性都是计算属性，通过 getter 和 setter 方法来访问和修改视图的 frame。setter 方法会直接修改 frame 的对应属性。
 优势：

 代码更简洁： 使用这些属性可以大大简化代码，提高可读性。
 方便快捷： 可以快速获取和设置视图的各种尺寸信息。
 提高开发效率： 减少了重复代码的编写。
 使用场景：

 布局： 快速设置视图的位置和大小。
 动画： 在动画过程中，直接修改这些属性可以简化代码。
 约束： 虽然有了 Auto Layout，但有时候直接修改 frame 仍然有它的用处，比如在自定义控件或动画效果中。
 注意事项：

 Auto Layout: 如果你的项目大量使用了 Auto Layout，直接修改 frame 可能会有冲突。建议在使用这些属性时，先禁用 Auto Layout 或者仔细考虑约束之间的关系。
 性能: 频繁修改 frame 属性可能会影响性能，尤其是在主线程上。对于复杂的视图层次结构，建议使用更优化的布局方式。
*/
