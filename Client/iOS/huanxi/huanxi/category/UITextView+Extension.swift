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
            placeholderLabel.isHidden = !self!.text.isEmpty
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
