//
//  UITextField+Extension.swift
//  huanxi
//
//  Created by jack on 2024/6/23.
//

import UIKit

extension UITextField {
    func setPlaceholderColor(_ color: UIColor) {
        guard let placeholder = self.placeholder else { return }
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                        attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}

/*这段代码为 UITextField 类添加了一个扩展方法，主要用于自定义文本框的占位文字颜色。
 
 代码解读：

 setPlaceholderColor(_:) 方法：
 参数： color: 需要设置的占位文字颜色。
 功能：
 获取占位文字： 获取当前文本框的 placeholder 属性。
 创建属性字符串： 使用 NSAttributedString 创建一个属性字符串，将占位文字和颜色关联起来。
 设置属性字符串： 将创建的属性字符串赋值给文本框的 attributedPlaceholder 属性，从而改变占位文字的颜色。
 代码优势：

 简化操作： 通过这个扩展方法，我们可以用一行代码轻松地设置占位文字的颜色，而不需要手动创建 NSAttributedString。
 可读性强： 代码逻辑清晰，易于理解。
 灵活性： 可以自定义任何颜色的占位文字。
 使用场景：

 个性化界面： 可以根据不同的主题或风格来设置不同的占位文字颜色。
 用户体验： 可以通过颜色来区分不同的输入框，提高用户体验。
 错误提示： 可以使用不同的颜色来表示不同的输入状态，比如错误输入时将占位文字颜色变为红色。
*/
