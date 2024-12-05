//
//  String+Extension.swift
//  huanxi
//
//  Created by rslz on 2024/11/11.
//

import Foundation
import UIKit

extension String {

    func substring(location index: Int, length: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(self.startIndex, offsetBy: index + length)
            let subString = self[startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }

    func substring(range: NSRange) -> String {
        if self.count > range.location {
            let startIndex = self.index(
                self.startIndex, offsetBy: range.location)
            let endIndex = self.index(
                self.startIndex, offsetBy: range.location + range.length)
            let subString = self[startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }

    static func formatCount(count: NSInteger) -> String {
        if count < 10000 {
            return String.init(count)
        } else {
            return (String.format(decimal: Float(count) / Float(10000)) ?? "0")
                + "w"
        }
    }

    static func format(
        decimal: Float, _ maximumDigits: Int = 1, _ minimumDigits: Int = 1
    ) -> String? {
        let number = NSNumber(value: decimal)
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = maximumDigits  //设置小数点后最多2位
        numberFormatter.minimumFractionDigits = minimumDigits  //设置小数点后最少2位（不足补0）
        return numberFormatter.string(from: number)
    }
    
    /// 计算文本高度
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}

extension NSAttributedString {
    func multiLineSize(width: CGFloat) -> CGSize {
        let rect = self.boundingRect(
            with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)),
            options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return CGSize.init(width: rect.size.width, height: rect.size.height)
    }
}
