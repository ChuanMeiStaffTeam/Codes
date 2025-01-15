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
