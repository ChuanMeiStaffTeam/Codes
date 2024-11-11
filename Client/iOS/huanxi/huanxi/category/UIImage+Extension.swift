//
//  UIImage+Extension.swift
//  huanxi
//
//  Created by rslz on 2024/11/12.
//

import UIKit

extension UIImage {
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
}
