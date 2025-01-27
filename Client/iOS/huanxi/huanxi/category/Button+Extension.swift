//
//  ButtonExtension.swift
//  MarkerMall
//
//  Created by Mac on 29.6.20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum Position {
    case ImagePositionLeft // 图片在左，文字在右，默认
    case ImagePositionRight // 图片在右，文字在左
    case ImagePositionTop // 图片在上，文字在下
    case ImagePositionBottom // 图片在下，文字在上
}

enum ImgPosition {
    case Left // 图片在左，文字在右，默认
    case Right // 图片在右，文字在左
    case Top // 图片在上，文字在下
    case Bottom // 图片在下，文字在上
}

var expandSizeKey = "expandSizeKey"

extension UIButton {
    func setImgPosition(postion: ImgPosition, spacing: CGFloat) {
        // 获取图像和标题的大小
        let imageSize = self.imageView?.intrinsicContentSize ?? CGSize.zero
        let titleSize = self.titleLabel?.intrinsicContentSize ?? CGSize.zero
        let changeDistance = titleSize.height / 2 + imageSize.height / 2 + spacing

        switch postion {
        case .Left:
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing / 2, bottom: 0, right: spacing / 2)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: -spacing / 2)
        case .Top:
            self.imageEdgeInsets = UIEdgeInsets(top: -changeDistance, left: (self.bounds.width - imageSize.width) / 2, bottom: 0, right: 0)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -changeDistance, right: 0)
        case .Right:
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleSize.width + spacing / 2, bottom: 0, right: -(titleSize.width + spacing / 2))
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageSize.width + spacing / 2), bottom: 0, right: imageSize.width + spacing / 2)
        case .Bottom:
            self.imageEdgeInsets = UIEdgeInsets(top: changeDistance, left: (self.bounds.width - imageSize.width) / 2, bottom: 0, right: 0)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: changeDistance, right: 0)
        }
    }

    /// 设置文字图片间隔
    func setImagePisition(postion: Position, spacing: CGFloat) {
        let imageWidth = self.imageView?.intrinsicContentSize.width ?? 0
        let imageHeight = self.imageView?.intrinsicContentSize.height ?? 0
        let txtStr = NSString(string: self.titleLabel?.text ?? "")

        var labelWidth = txtStr.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel?.font ?? UIFont.systemFontSize]).width

        let labelHeight = txtStr.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel?.font ?? UIFont.systemFontSize]).height

        if postion == Position.ImagePositionLeft, labelWidth >= CGFloat(self.frame.size.width - imageWidth) {
            labelWidth = self.frame.size.width - imageWidth
        }

        let imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2 // image中心移动的x距离
        let imageOffsetY = imageHeight / 2 + spacing / 2 // image中心移动的y距离
        let labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2 // label中心移动的x距离
        let labelOffsetY = labelHeight / 2 + spacing / 2 // label中心移动的y距离

        let tempWidth = max(labelWidth, imageWidth)
        let changedWidth = labelWidth + imageWidth - tempWidth
        let tempHeight = max(labelHeight, imageHeight)
        let changedHeight = labelHeight + imageHeight + spacing - tempHeight

        switch postion {
        case .ImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing / 2, bottom: 0, right: spacing / 2)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: -spacing / 2)
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: spacing / 2)

        case .ImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + spacing / 2, bottom: 0, right: -(labelWidth + spacing / 2))
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageWidth + spacing / 2), bottom: 0, right: imageWidth + spacing / 2)
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: spacing / 2)

        case .ImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsets(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
            self.titleEdgeInsets = UIEdgeInsets(top: labelOffsetY, left: -labelOffsetX, bottom: -labelOffsetY, right: labelOffsetX)
            self.contentEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: -changedWidth / 2, bottom: changedHeight - imageOffsetY, right: -changedWidth / 2)

        case .ImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
            self.titleEdgeInsets = UIEdgeInsets(top: -labelOffsetY, left: -labelOffsetX, bottom: labelOffsetY, right: labelOffsetX)
            self.contentEdgeInsets = UIEdgeInsets(top: changedHeight - imageOffsetY, left: -changedWidth / 2, bottom: imageOffsetY, right: -changedWidth / 2)
        }
        self.layoutIfNeeded()
    }

    public class func ck_button(title: String?, titleColor: UIColor?, bgColor: UIColor?, fontSize: CGFloat?) -> UIButton {
        let btn = UIButton()
        btn.adjustsImageWhenHighlighted = false
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize ?? 14)
        btn.backgroundColor = bgColor
        btn.setTitleColor(titleColor, for: .normal)
        btn.setTitle(title, for: .normal)
        return btn
    }

    /// 默认
    public class func ck_default_button() -> UIButton {
        return self.ck_button(title: nil, titleColor: nil, bgColor: nil, fontSize: nil)
    }

    public func lin_expandSize(size: CGFloat) {
        objc_setAssociatedObject(self, &expandSizeKey, size, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }

    private func expandRect() -> CGRect {
        let expandSize = objc_getAssociatedObject(self, &expandSizeKey)
        if expandSize != nil {
            return CGRect(x: bounds.origin.x - (expandSize as! CGFloat), y: bounds.origin.y - (expandSize as! CGFloat), width: bounds.size.width + 2*(expandSize as! CGFloat), height: bounds.size.height + 2*(expandSize as! CGFloat))
        } else {
            return bounds
        }
    }

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRect = self.expandRect()
        if buttonRect.equalTo(bounds) {
            return super.point(inside: point, with: event)
        } else {
            return buttonRect.contains(point)
        }
    }
}

extension Reactive where Base: UIButton {
    /// 添加节流功能的按钮点击事件
    func tapThrottle(interval: RxTimeInterval = .milliseconds(600)) -> ControlEvent<Void> {
        //latest = false：在间隔内只发送第一个事件，忽略间隔内的后续事件
        let source = self.tap
            .throttle(interval, latest: false, scheduler: MainScheduler.instance) // 节流逻辑
        return ControlEvent(events: source)
    }
}

/*代码功能：
 
 这段代码为 UIButton 类添加了一些自定义的功能，主要涉及以下方面：

 图像和文本布局： 可以灵活地调整按钮中图像和文本的相对位置。
 按钮外观定制： 提供了一些便捷的方法来创建自定义外观的按钮。
 点击事件节流： 使用 RxSwift 实现按钮点击事件的节流功能，防止在短时间内多次点击。
 触摸区域扩展： 允许通过 lin_expandSize 方法扩大按钮的触摸区域。
 详细解释：

 Position 和 ImgPosition 枚举： 定义了图像和文本在按钮中的相对位置，如左、右、上、下。
 setImgPosition 和 setImagePisition 方法： 这两个方法的作用基本相同，都是通过调整 imageEdgeInsets 和 titleEdgeInsets 来设置图像和文本的位置。区别在于 setImagePisition 方法会根据按钮的尺寸和文本长度进行更复杂的计算，以确保布局合理。
 ck_button 方法： 一个工厂方法，用于快速创建一个自定义的按钮，可以设置标题、标题颜色、背景颜色和字体大小。
 lin_expandSize 方法： 使用关联对象存储一个扩展尺寸的值，用于扩大按钮的触摸区域。
 point(inside:with:) 方法： 重写了 UIButton 的这个方法，使得按钮的触摸区域不再局限于其可视范围，而是扩展到了关联的扩展尺寸。
 tapThrottle 扩展方法： 使用 RxSwift 的 throttle 操作符对按钮的点击事件进行节流，避免在短时间内多次触发点击事件。
 代码亮点：

 灵活的布局： 可以根据需要调整图像和文本的位置。
 扩展性强： 通过关联对象的方式，可以为按钮添加自定义属性。
 性能优化： 使用 RxSwift 的 throttle 操作符优化了点击事件的处理。
 潜在问题和改进建议：

 代码冗余： setImgPosition 和 setImagePisition 方法的功能相似，可以考虑合并。
 命名不规范： ImgPosition 和 setImagePisition 的命名可能存在一些小问题，建议使用更规范的命名方式。
 缺少注释： 代码中缺少详细的注释，对于后续维护和理解会带来不便。
 硬编码值： 一些数值（如间距、字体大小）被硬编码，缺乏灵活性。
 建议改进：

 统一命名： 将 ImgPosition 改为 Position，并统一命名规范。
 简化逻辑： 合并 setImgPosition 和 setImagePisition 方法，减少冗余代码。
 添加注释： 为关键代码添加注释，解释代码的意图。
 使用常量： 将一些常量值定义为常量，提高代码的可读性和可维护性。
 考虑使用约束布局： 对于更复杂的布局，可以考虑使用 Auto Layout 或第三方约束布局框架来实现。
 提供更多自定义选项： 可以提供更多的选项来定制按钮的外观和行为，例如圆角、阴影等。
*/
