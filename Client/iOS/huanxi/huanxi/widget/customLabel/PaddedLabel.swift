//
//  PaddedLabel.swift
//  huanxi
//
//  Created by rslz on 2024/11/9.
//

import UIKit

class PaddedLabel: UILabel {
    
    var padding: UIEdgeInsets = .zero
    
    override func drawText(in rect: CGRect) {
        // 调整文本绘制区域
        let paddedRect = rect.inset(by: padding)
        super.drawText(in: paddedRect)
    }
    
    override var intrinsicContentSize: CGSize {
        // 调整内容大小
        let contentSize = super.intrinsicContentSize
        let width = contentSize.width + padding.left + padding.right
        let height = contentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: height)
    }
}
/*代码功能：
 
 这段 Swift 代码定义了一个自定义的 UILabel 子类，名为 PaddedLabel。这个子类在原有 UILabel 的基础上，增加了对文本内容进行内边距设置的功能。

 代码详解：

 padding 属性：
 这个属性是一个 UIEdgeInsets 类型，用于表示上下左右四个方向的内边距。通过设置这个属性，可以控制文本与标签边框之间的距离。
 drawText(in:) 方法：
 这个方法是用来绘制文本的。在这个方法中，首先通过 inset(by:) 方法将传入的 rect 缩小了 padding 的大小，得到一个新的 paddedRect。然后，调用父类的 drawText(in:) 方法，将文本绘制在这个缩小的矩形区域内。这样就实现了文本内容向内偏移的效果。
 intrinsicContentSize 属性：
 这个属性表示控件的内在尺寸，即控件根据其内容自适应的大小。在这个方法中，首先调用父类的 intrinsicContentSize 获取文本的原始大小，然后加上 padding 的宽度和高度，得到最终的内在尺寸。
 代码作用：

 通过自定义 PaddedLabel 类，我们可以方便地在 UILabel 中添加内边距，从而实现文本与标签边框之间的间距控制。这在布局时非常有用，可以使界面更加美观和灵活。*/
