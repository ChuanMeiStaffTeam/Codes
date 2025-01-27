//
//  UIColor+Extension.swift
//  huanxi
//
//  Created by jack on 2024/2/29.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func brightened(by factor: CGFloat) -> UIColor {
      var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
      getHue(&h, saturation: &s, brightness: &b, alpha: &a)
      return UIColor(hue: h, saturation: s, brightness: b * factor, alpha: a)
    }
    
    static var mainBlueColor: UIColor {
        return .init(hexString: "#009DFF")
    }
    
    static var linkColor: UIColor {
        return .init(hexString: "#0098FE")
    }
    
    static var postBlueColor: UIColor {
        return .init(hexString: "#0098FE")
    }
    
    static var postBgColor: UIColor {
        return .init(hexString: "#212328")
    }
    
    static var white_10: UIColor {
        return .init(hexString: "#FFFFFF",alpha: 0.1)
    }
    
    static var white_60: UIColor {
        return .init(hexString: "#FFFFFF",alpha: 0.6)
    }
    
    static var white_80: UIColor {
        return .init(hexString: "#FFFFFF",alpha: 0.8)
    }
    
    static var black_40: UIColor {
        return .init(hexString: "#000000",alpha: 0.4)
    }
    
    static var black_60: UIColor {
        return .init(hexString: "#000000",alpha: 0.6)
    }
    
    static var black_forground: UIColor {
        return .init(hexString: "#191919",alpha: 1)
    }
    
}

/*这段代码为 UIColor 类添加了一些扩展方法，主要用于简化颜色的创建和使用。

核心功能：

十六进制颜色创建: 提供了两个初始化方法，分别通过十六进制整数和十六进制字符串来创建 UIColor 对象。这使得我们可以直接使用十六进制颜色值来定义颜色，而不需要手动计算 RGB 成分。
颜色亮度调整: brightened(by:) 方法可以将颜色的亮度增加一个指定倍数。
预定义颜色: 定义了一些常用的颜色，如 mainBlueColor, linkColor 等，方便在项目中直接使用。
代码解读：

init(hex:alpha:) 和 init(hexString:alpha:):
这两个初始化方法通过将十六进制值转换为 RGB 值来创建 UIColor 对象。
alpha 参数用于设置颜色的透明度。
brightened(by:):
该方法将 UIColor 转换为 HSB 色彩空间，然后增加亮度值，最后再转换回 RGB 色彩空间。
预定义颜色:
定义了一些常用的颜色，方便在项目中直接使用，提高代码可读性。
优点：

方便快捷: 可以直接使用十六进制字符串创建颜色，减少了代码量。
可读性强: 使用十六进制颜色值可以更直观地表示颜色。
可扩展性: 可以根据需要添加更多的自定义颜色和颜色操作方法。
应用场景：

UI 设计: 可以快速定义各种颜色，用于界面设计。
主题定制: 可以通过修改预定义的颜色来实现主题切换。
颜色计算: 可以基于现有颜色进行调整，比如增加亮度、降低饱和度等。*/

