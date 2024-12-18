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
