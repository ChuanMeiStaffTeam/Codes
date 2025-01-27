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

        for (_, (substring, color)) in tapStyles.enumerated() {
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


/*这段代码定义了一个名为 RichTextLabel 的自定义 UILabel 子类，用于处理富文本中的点击事件。
 
 核心功能:

 设置富文本和点击范围:

 setRichText(_:attributes:tapStyles:) 方法用于设置标签的文本内容、属性（如字体、颜色）和点击范围。
 该方法会根据传入的 tapStyles 数组，在富文本中找到对应的子字符串，并为这些子字符串设置点击样式（如颜色、下划线）。
 同时，该方法会记录每个可点击子字符串的范围、内容和索引，以便后续处理点击事件。
 处理点击事件:

 handleTap(_:) 方法用于处理用户点击标签上的手势。
 该方法会根据点击的位置计算出对应的字符索引。
 然后，遍历记录的点击范围，查找点击位置是否在某个可点击子字符串的范围内。
 如果找到匹配的子字符串，则调用 onTextTapped 回调函数，将子字符串、范围和索引传递给外部。
 获取点击的文字范围和内容:

 getTappedString(at:) 方法用于根据点击的位置获取对应的子字符串、范围和索引。
 该方法使用 NSTextStorage、NSLayoutManager 和 NSTextContainer 这些核心文本框架类来计算点击位置对应的字符索引。
 然后，遍历记录的点击范围，查找匹配的子字符串。
 代码结构:

 tapRanges：存储可点击子字符串的范围、内容和颜色的数组。
 onTextTapped：点击事件回调，用于将点击信息传递给外部。
 setRichText(_:attributes:tapStyles:)：设置富文本和点击范围。
 handleTap(_:)：处理点击手势。
 getTappedString(at:)：获取点击的文字范围和内容。
 
 优点:

 灵活: 可以自定义点击范围和样式。
 可扩展性: 可以根据需要添加其他功能，如高亮显示、动画效果等。
 易于使用: 提供了简单易用的接口，方便集成到其他控件中。
 改进点:

 性能优化: 对于大量文本或频繁点击，可以考虑优化 getTappedString(at:) 方法的性能。
 可读性: 可以使用更清晰的变量名和注释来提高代码的可读性。*/
