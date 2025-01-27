//
//  UITextView+Extension.swift
//  huanxi
//
//  Created by jack on 2024/3/24.
//

import UIKit

extension UITextView {
    func addPlaceholder(_ placeholder: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.sizeToFit()
        placeholderLabel.font = self.font
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 8)
        placeholderLabel.isHidden = !self.text.isEmpty
        self.addSubview(placeholderLabel)
        
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: self, queue: .main) { [weak self] _ in
            guard let `self` = self else { return }
            DispatchQueue.main.async{
                placeholderLabel.isHidden = !self.text.isEmpty
            }
        }
    }
    
    func setMaxLength(_ maxLength: Int) {
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: self, queue: .main) { [weak self] _ in
            guard let text = self?.text else { return }
            if text.count > maxLength {
                self?.text = String(text.prefix(maxLength))
            }
        }
    }
}

/*代码分析：UIColor 扩展，简化颜色创建与使用
 这段代码主要为 UIColor 类添加了一些扩展方法，方便我们更便捷地创建和使用颜色。

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
