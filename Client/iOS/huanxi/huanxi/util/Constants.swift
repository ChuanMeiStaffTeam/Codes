//
//  Constants.swift
//  huanxi
//
//  Created by rslz on 2024/11/11.
//

import Foundation
import UIKit


let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

func getKeyWindow() -> UIWindow? {
    if #available(iOS 13, *) {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    } else {
        return UIApplication.shared.keyWindow
    }
}

/*代码分析：Constants.swift
 这段代码定义了两个全局常量和一个获取当前 KeyWindow 的函数。

 全局常量

 screenWidth: 屏幕的宽度，单位为像素点 (pt)。
 screenHeight: 屏幕的高度，单位为像素点 (pt)。
 这两个常量直接获取了主屏幕的尺寸信息，方便在代码中直接使用屏幕的宽高进行布局或计算。

 函数 getKeyWindow()

 该函数用于获取当前应用程序的 KeyWindow。
 KeyWindow 是用户正在交互的窗口，通常是包含应用主界面的窗口。
 函数使用了不同的 iOS 版本兼容方式：

 iOS 13 及以上版本:
 利用 connectedScenes 属性获取所有连接的场景 (Scene)。
 筛选出类型为 UIWindowScene 的场景。
 获取该场景中的所有窗口集合 (windows)。
 找到 isKeyWindow 为 true 的窗口，即 KeyWindow。
 iOS 12 及以下版本:
 直接使用 UIApplication.shared.keyWindow 属性获取 KeyWindow。
 代码优点

 方便实用：全局常量可以直接获取屏幕尺寸，getKeyWindow() 函数简化了获取 KeyWindow 的操作。
 版本兼容：通过不同的实现方式兼容了不同版本的 iOS 系统。
 潜在改进

 常量命名: 考虑使用更具描述性的命名，例如 mainScreenWidth 和 mainScreenHeight。
 错误处理: getKeyWindow() 函数没有考虑找不到 KeyWindow 的情况，可以添加相应的判断或错误处理。
*/
