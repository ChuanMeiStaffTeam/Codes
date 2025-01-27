//
//  UIImage+Extension.swift
//  huanxi
//
//  Created by rslz on 2024/11/12.
//

import UIKit

extension UIImage {
    
    /// UIImage设置Padding
    func withPadding(_ insets: UIEdgeInsets) -> UIImage? {
        let size = CGSize(
            width: self.size.width + insets.left + insets.right,
            height: self.size.height + insets.top + insets.bottom
        )
        
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithPadding = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageWithPadding
    }
    
    /// 根据颜色生成UIImage
    static func ImageWithColor(_ color: UIColor, size: CGSize, cornerRadius: CGFloat = 0) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            // 创建圆角路径（如果 cornerRadius > 0）
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            // 设置填充颜色
            color.setFill()
            // 填充路径
            path.fill()
        }
        return image
    }
}


/*UIImage 扩展分析：添加图片填充和生成纯色图片功能
这段代码为 UIImage 类添加了两个扩展方法，用于处理图片的填充和生成纯色图片。

功能详解：

withPadding(_:) 方法

为图片添加指定边距的填充效果。
参数 insets: UIEdgeInsets 结构体，代表上下左右的边距值。
通过计算新的尺寸，创建绘图上下文。
将原图绘制到留有边距的新位置上。
从当前绘图上下文中获取生成的新图片并返回。
ImageWithColor(_:size:cornerRadius:) 方法

根据提供的颜色和尺寸生成一张纯色图片。
参数:
color: 用于填充图片的 UIColor 值。
size: 生成图片的 CGSize 尺寸。
cornerRadius (可选): 设置图片的圆角半径 (默认为 0, 即非圆角矩形)。
使用 UIGraphicsImageRenderer 创建指定尺寸的绘图上下文。
在代码块中:
定义一个矩形区域，大小为 size。
(可选) 如果 cornerRadius 大于 0，则创建具有圆角的贝塞尔路径。
设置填充颜色为 color。
使用路径填充矩形区域。
从绘图上下文中获取生成的图片并返回。
优势：

封装常用功能: 简化了为图片添加边距和生成纯色图片的操作。
可定制: 可以通过 insets 和 cornerRadius 参数来自定义填充效果和圆角样式。
易于使用: 方法名和参数清晰易懂。
使用场景：

图片布局: 为图片添加边距可以更灵活地控制其在视图中的位置。
装饰元素: 可以使用纯色图片作为装饰元素，比如按钮的背景色等。
圆角图片: 通过设置 cornerRadius 可以生成圆角的纯色图片。*/
