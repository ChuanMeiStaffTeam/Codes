//
//  UIView+Extension.swift
//  huanxi
//
//  Created by rslz on 2024/12/20.
//

import UIKit

extension UIView {

    private var skeletonLayer: CAGradientLayer? {
        return self.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer
    }
    
    // 创建并返回一个骨架渐变层
    private func createSkeletonLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.postBgColor.cgColor, UIColor.postBgColor.brightened(by: 0.93).cgColor, UIColor.postBgColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: -0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.5, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = self.bounds
        gradientLayer.isHidden = true  // Initially hidden
        self.layer.addSublayer(gradientLayer)
        return gradientLayer
    }

    // 启动骨架屏动画
    func startSkeletonAnimation() {
        guard let gradientLayer = self.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer else {
            let newLayer = createSkeletonLayer()
            startLayerAnimation(for: newLayer)
            return
        }
        startLayerAnimation(for: gradientLayer)
    }

    // 停止骨架屏动画
    func stopSkeletonAnimation() {
        guard let gradientLayer = self.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer else { return }
        gradientLayer.removeAnimation(forKey: "skeletonAnimation")
        gradientLayer.isHidden = true
    }

    // 更新骨架层的 frame
    func layoutSkeletonLayer() {
        skeletonLayer?.frame = self.bounds
    }

    // 执行骨架层的动画
    private func startLayerAnimation(for gradientLayer: CAGradientLayer) {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-0.5, 0.0, 0.5]
        animation.toValue = [0.5, 1.0, 1.5]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "skeletonAnimation")
        gradientLayer.isHidden = false
    }
}

extension ViewChainable where Self: UIView {
    @discardableResult
    func then(_ config: (Self) -> Void) -> Self {
        config(self)
        return self
    }
}
extension UIView: ViewChainable {
    
}
protocol ViewChainable {

}
