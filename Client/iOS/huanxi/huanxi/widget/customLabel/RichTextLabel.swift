//
//  RichTextLabel.swift
//  huanxi
//
//  Created by rslz on 2024/11/19.
//

import UIKit

class RichTextLabel: UILabel {
    // 点击文字的范围和样式
    private var tapRanges: [(range: NSRange, string: String, color: UIColor)] = []

    // 点击事件回调
    var onTextTapped: ((String, NSRange, Int) -> Void)?

    // 设置富文本及点击范围
    func setRichText(_ text: String,
                     attributes: [NSAttributedString.Key: Any],
                     tapStyles: [(String, UIColor)]) {
        let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
        tapRanges.removeAll()

        for (index, (substring, color)) in tapStyles.enumerated() {
            if let range = text.range(of: substring) {
                let nsRange = NSRange(range, in: text)
                attributedString.addAttributes([
                    .foregroundColor: color,
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                ], range: nsRange)
                tapRanges.append((range: nsRange, string: substring, color: color))
            }
        }

        attributedText = attributedString
        isUserInteractionEnabled = true

        if gestureRecognizers?.isEmpty ?? true {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            addGestureRecognizer(tapGesture)
        }
    }

    /// 手势处理
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        if let tappedData = getTappedString(at: location) {
            onTextTapped?(tappedData.string, tappedData.range, tappedData.index)
        }
    }

    /// 获取点击的文字范围和内容
    private func getTappedString(at point: CGPoint) -> (string: String, range: NSRange, index: Int)? {
        guard let attributedText = attributedText else { return nil }

        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineBreakMode = lineBreakMode

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        for (i, tapRange) in tapRanges.enumerated() {
            if NSLocationInRange(index, tapRange.range) {
                return (tapRange.string, tapRange.range, i)
            }
        }
        return nil
    }
}
