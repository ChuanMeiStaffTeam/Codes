//
//  Notification+Extension.swift
//  huanxi
//
//  Created by rslz on 2024/11/11.
//

import Foundation
import UIKit

extension Notification {
    
    func keyBoardHeight() -> CGFloat {
        if let userInfo = self.userInfo {
            if let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let size = value.cgRectValue.size
                return UIInterfaceOrientation.portrait.isLandscape ? size.width : size.height
            }
        }
        return 0
    }
    
}


extension Notification.Name {
    static let refreshMainPageNotification = Notification.Name("refreshMainPageNotification")
    static let collectNotification = Notification.Name("collectNotification")
}

/*代码分析：Notification 扩展，获取键盘高度和自定义通知名称
 这段代码为 Notification 类和 Notification.Name 类型添加了一些扩展方法。

 1. Notification 扩展：获取键盘高度

 keyBoardHeight() 方法:
 从通知的 userInfo 字典中获取键盘即将出现的位置信息 (UIResponder.keyboardFrameEndUserInfoKey)。
 解析出键盘的尺寸 (size)。
 根据当前设备的方向 (UIInterfaceOrientation)，返回键盘的高度 (portrait 竖屏下是 height，landscape 横屏下是 width)。
 如果无法解析出键盘信息，则返回 0。
 2. Notification.Name 扩展：自定义通知名称

 定义了两个静态常量属性：
 refreshMainPageNotification: 常用于刷新主界面的通知名称。
 collectNotification: 常用于收藏操作的通知名称。
 代码优势：

 简化键盘高度获取: 提供了一个方便的方法来获取键盘即将出现的高度，避免了手动解析 userInfo 字典的复杂性。
 可读性强: 代码清晰易懂。
 代码重用: 自定义的通知名称提高了代码的可读性和可维护性。
 使用场景：

 键盘处理: 在需要根据键盘弹出/收起调整 UI 布局的场景下，可以使用 keyBoardHeight() 方法获取键盘高度。
 事件通知: 可以使用自定义的通知名称 (refreshMainPageNotification 和 collectNotification) 来进行组件间的通信，提高代码的可维护性。*/

