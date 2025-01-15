//
//  UIView+Extension.swift
//  huanxi
//
//  Created by rslz on 2024/12/20.
//

import UIKit
import RxCocoa
import RxSwift

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

// MARK: - .then语法初始化View
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


// MARK: - 扩展 UIView 来添加点击手势的 Rx 支持
extension Reactive where Base: UIView {
    /// 添加节流功能的点击事件
    func tapGestureThrottle(interval: RxTimeInterval = .milliseconds(500)) -> ControlEvent<Void> {
        //latest = false：在间隔内只发送第一个事件，忽略间隔内的后续事件
        let source = self.tapGesture
            .throttle(interval, latest: false, scheduler: MainScheduler.instance)
        return ControlEvent(events: source)
    }
    /// UIView 点击手势的 Rx 支持
    var tapGesture: Observable<Void> {
        return Observable.create { [weak base] observer in
            // 确保 UIView 存在
            guard let view = base else {
                observer.onCompleted()
                return Disposables.create()
            }

            // 创建 UITapGestureRecognizer
            let tapGesture = UITapGestureRecognizer()
            view.addGestureRecognizer(tapGesture)
            view.isUserInteractionEnabled = true // 确保视图可交互

            // 手势触发时发出事件
            let target = GestureTarget(gestureRecognizer: tapGesture) {
                DispatchQueue.main.async { // 确保事件在主线程中发出
                    observer.onNext(())
                }
            }

            // 返回一个 Disposables，当 Observable 被销毁时，移除手势
            return Disposables.create {
                DispatchQueue.main.async { // 确保移除手势操作在主线程
                    view.removeGestureRecognizer(tapGesture)
                }
                target.dispose()
            }
        }
        .observe(on: MainScheduler.instance) // 确保订阅者在主线程处理事件
    }
}

// 用于管理手势的 Target
private class GestureTarget: NSObject {
    private let gestureRecognizer: UIGestureRecognizer
    private let action: () -> Void

    init(gestureRecognizer: UIGestureRecognizer, action: @escaping () -> Void) {
        self.gestureRecognizer = gestureRecognizer
        self.action = action
        super.init()
        gestureRecognizer.addTarget(self, action: #selector(handleGesture))
    }

    @objc private func handleGesture() {
        action()
    }

    func dispose() {
        gestureRecognizer.removeTarget(self, action: #selector(handleGesture))
    }
}
