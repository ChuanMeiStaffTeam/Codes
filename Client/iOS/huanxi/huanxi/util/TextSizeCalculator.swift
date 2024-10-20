//
//  TextSizeCalculator.swift
//  huanxi
//
//  Created by Jack on 2024/6/7.
//

import UIKit

class TextSizeCalculator {
    
    /// 根据最大宽度和文本内容计算文本的高度
    /// - Parameters:
    ///   - text: 要计算的文本
    ///   - font: 文本字体
    ///   - maxWidth: 文本显示的最大宽度
    ///   - lineSpacing: 行间距
    /// - Returns: 文本内容所需的高度
    static func calculateHeight(for text: String, with font: UIFont, maxWidth: CGFloat, lineSpacing: CGFloat) -> CGFloat {
        // 创建一个NSMutableParagraphStyle实例
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        // 创建属性字典
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        
        // 创建一个CGSize，宽度为最大宽度，高度为无限大
        let size = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        
        // 计算文本所需的矩形区域
        let boundingRect = (text as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        // 返回文本内容所需的高度
        return ceil(boundingRect.height)
    }
    
    /// 根据固定高度和文本内容计算文本的宽度
    /// - Parameters:
    ///   - text: 要计算的文本
    ///   - font: 文本字体
    ///   - fixedHeight: 文本显示的固定高度
    /// - Returns: 文本内容所需的宽度
    static func calculateWidth(for text: String, with font: UIFont, fixedHeight: CGFloat) -> CGFloat {
        // 创建属性字典
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        
        // 创建一个CGSize，宽度为无限大，高度为固定高度
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: fixedHeight)
        
        // 计算文本所需的矩形区域
        let boundingRect = (text as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        // 返回文本内容所需的宽度
        return ceil(boundingRect.width)
    }
}

