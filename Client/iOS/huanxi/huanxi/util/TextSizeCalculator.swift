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

/*代码分析：文本尺寸计算工具类
代码功能

这段代码定义了一个名为 TextSizeCalculator 的类，提供了两个静态方法，用于计算文本在指定约束下的尺寸。

calculateHeight(for:with:maxWidth:lineSpacing:): 根据给定的文本、字体、最大宽度和行间距，计算文本所占用的高度。
calculateWidth(for:with:fixedHeight:): 根据给定的文本、字体和固定高度，计算文本所占用的宽度。
工作原理

这两个方法都使用了 boundingRect(with:options:attributes:context:) 方法来计算文本的矩形区域。这个方法是 NSString 的一个实例方法，可以根据给定的约束、字体和属性来计算文本所占用的矩形区域。

创建属性字典: 将字体和段落样式（包括行间距）等属性封装到一个字典中。
创建 CGSize: 根据计算需求，创建一个 CGSize 对象，指定宽或高为无限大，另一个维度为已知值。
计算 boundingRect: 调用 boundingRect 方法，传入 CGSize、选项、属性字典等参数，获取文本的矩形区域。
返回结果: 返回矩形的 height 或 width 作为计算结果。
代码亮点

封装性好: 将文本尺寸计算封装成静态方法，方便调用。
灵活: 可以根据不同的需求计算文本的高度或宽度。
准确性: 使用 boundingRect 方法可以准确计算文本的尺寸，考虑了字体、行间距等因素。
使用场景

自适应布局: 根据文本内容动态调整 UI 元素的大小。
文本截断: 判断文本是否超出显示区域，需要进行截断。
动态表格单元格高度: 根据文本内容动态计算单元格的高度。
注意事项

性能: 频繁调用 boundingRect 方法可能会影响性能，对于大量文本的计算，可以考虑缓存计算结果。
复杂布局: 对于复杂的布局，可能需要考虑更多的因素，例如文本对齐方式、缩进等。
字体变化: 如果字体发生变化，需要重新计算文本尺寸。

拓展

支持富文本: 可以扩展方法，支持计算富文本的尺寸。
支持多行文本: 可以通过调整 options 参数来处理多行文本。
支持不同语言: 对于不同语言的文本，可能需要考虑字体和字符宽度差异。*/
