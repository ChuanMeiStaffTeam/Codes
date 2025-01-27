//
//  Overlay.swift
//  DrawerView
//
//  Created by Mikko Välimäki on 2018-01-04.
//  Copyright © 2018 Mikko Välimäki. All rights reserved.
//

import UIKit

class Overlay: UIView {

    private var _mask = CAShapeLayer()

    public var cornerRadius: CGFloat = 8

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.clipsToBounds = false
    }

    override func layoutSubviews() {
        let path = CGMutablePath()

        _mask.frame = self.bounds

        var clipping = self.bounds
        clipping.origin.y = self.bounds.size.height - cornerRadius

        path.addRect(self.bounds)
        path.addRoundedRect(in: clipping, cornerWidth: cornerRadius, cornerHeight: cornerRadius)

        _mask.path = path
        #if swift(>=4.2)
        _mask.fillRule = .evenOdd
        #else
        _mask.fillRule = kCAFillRuleEvenOdd
        #endif

        self.layer.mask = _mask
    }
}

/* Overlay 类

 这个类似乎定义了一个自定义的视图，用于创建一种特殊的遮罩效果。

 _mask 属性：
 创建了一个 CAShapeLayer 对象，这个对象将作为视图的遮罩层。
 遮罩层可以控制视图的哪些部分可见，哪些部分不可见。
 cornerRadius 属性：
 这个属性用于设置遮罩层的圆角半径，从而控制遮罩层的形状。
 layoutSubviews 方法：
 在每次布局子视图时都会调用这个方法。
 在这个方法中，创建了一个 CGMutablePath 对象，用于定义遮罩层的形状。
 这个形状是一个矩形，底部有一个圆角。
 将这个路径赋值给 _mask 层，从而实现遮罩效果。
 由于设置了 fillRule 为 evenOdd，所以位于圆角矩形外部的区域会被视为“内部”，从而实现了遮罩的效果。
 可能的用途：

 抽屉效果： 这个类可能用于实现抽屉效果，遮罩层可以用来遮挡底层视图。
 弹窗效果： 可以用作弹窗的背景，实现半透明遮罩效果。
 自定义控件： 可以作为其他自定义控件的底层实现，提供特定的视觉效果。*/
