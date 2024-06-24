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
