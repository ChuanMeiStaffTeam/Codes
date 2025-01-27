//
//  UIView+FrameExtension.swift
//  huanxi
//
//  Created by jack on 2024/2/27.
//

import UIKit

extension UIView {
    
    var parentViewController: UIViewController? {
        var nextResponder: UIResponder? = self
        while let responder = nextResponder {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            nextResponder = responder.next
        }
        return nil
    }
    
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }

    var bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set {
            frame.origin.y = newValue - frame.size.height
        }
    }
    
    var right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set {
            frame.origin.x = newValue - frame.size.width
        }
    }
    
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }

    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }

    var size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }

    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            frame.origin = newValue
        }
    }
}

/*这段代码为 UIView 类添加了一些便捷属性，方便我们更直观地操作视图的 frame。
 
 核心功能：

 简化 frame 的访问和修改：
 直接通过 x, y, width, height, size, origin 等属性来访问和修改视图的坐标和尺寸，而不用每次都写 frame.origin.x 这种冗长的代码。
 提供 bottom 和 right 属性： 方便获取视图的底部和右边的坐标。
 获取父视图控制器： parentViewController 属性可以快速获取当前视图的父视图控制器。
 代码解读：

 parentViewController: 通过遍历响应者链，找到最近的 UIViewController。这在需要访问视图控制器的方法或属性时非常有用，比如展示弹窗、修改导航栏等。
 x, y, width, height, size, origin: 这些属性都是计算属性，通过 getter 和 setter 方法来访问和修改视图的 frame。setter 方法会直接修改 frame 的对应属性。
 使用场景：

 布局： 快速设置视图的位置和大小。
 动画： 在动画过程中，直接修改这些属性可以简化代码。
 约束： 虽然有了 Auto Layout，但有时候直接修改 frame 仍然有它的用处，比如在自定义控件或动画效果中。

 需要注意的是：

 Auto Layout: 如果你的项目大量使用了 Auto Layout，直接修改 frame 可能会有冲突。建议在使用这些属性时，先禁用 Auto Layout 或者仔细考虑约束之间的关系。
 性能: 频繁修改 frame 属性可能会影响性能，尤其是在主线程上。对于复杂的视图层次结构，建议使用更优化的布局方式。*/
