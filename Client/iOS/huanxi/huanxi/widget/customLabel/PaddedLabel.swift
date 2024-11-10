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
