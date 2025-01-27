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
    
    /// UIView 长按手势的 Rx 支持
    var longPressGesture: Observable<Void> {
        return Observable.create { [weak base] observer in
            // 确保 UIView 存在
            guard let view = base else {
                observer.onCompleted()
                return Disposables.create()
            }

            // 创建 UILongPressGestureRecognizer
            let longPressGesture = UILongPressGestureRecognizer()
            view.addGestureRecognizer(longPressGesture)
            view.isUserInteractionEnabled = true // 确保视图可交互

            // 手势触发时发出事件
            let target = GestureTarget(gestureRecognizer: longPressGesture) {
    
                // 检查手势状态，只处理 .began 状态
                if longPressGesture.state == .began {
                    DispatchQueue.main.async { // 确保事件在主线程中发出
                        observer.onNext(())
                    }
                }
            }

            // 返回一个 Disposables，当 Observable 被销毁时，移除手势
            return Disposables.create {
                DispatchQueue.main.async { // 确保移除手势操作在主线程
                    view.removeGestureRecognizer(longPressGesture)
                }
                target.dispose()
            }
        }
        .observe(on: MainScheduler.instance) // 确保订阅者在主线程处理事件
    }
}

// MARK: - itemLongPressed
extension Reactive where Base: UITableView {
    var itemLongPressed: ControlEvent<IndexPath> {
        let source = Observable<IndexPath>.create { [weak base] observer in
            guard let tableView = base else {
                observer.onCompleted()
                return Disposables.create()
            }

            let longPressGesture = UILongPressGestureRecognizer()
            tableView.addGestureRecognizer(longPressGesture)

            let target = GestureTarget(gestureRecognizer: longPressGesture) {
                guard let tableView = base else { return }
                // 检查手势状态，只处理 .began 状态
                if longPressGesture.state == .began {
                    let point = longPressGesture.location(in: tableView)
                    if let indexPath = tableView.indexPathForRow(at: point) {
                        observer.onNext(indexPath)
                    }
                }
            }

            return Disposables.create {
                tableView.removeGestureRecognizer(longPressGesture)
                target.dispose()
            }
        }
        .observe(on: MainScheduler.instance)

        return ControlEvent(events: source)
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


/*代码分析：UIView 扩展，添加骨架屏、链式调用、手势识别等功能
 整体概述

 这段代码为 UIView 类添加了多个扩展方法，主要用于实现以下功能：

 骨架屏效果: 通过 CAGradientLayer 实现视图的骨架屏效果，在数据加载过程中提供视觉反馈。
 链式调用: 使用 ViewChainable 协议，实现类似于 SwiftUI 的链式调用语法，方便配置视图属性。
 手势识别: 为 UIView 添加了 tapGesture 和 longPressGesture 属性，方便使用 RxSwift 订阅手势事件。
 UITableView 长按事件: 为 UITableView 添加了 itemLongPressed 属性，用于监听长按事件。
 详细分析

 骨架屏部分

 skeletonLayer: 私有属性，用于存储骨架层的 CAGradientLayer 对象。
 createSkeletonLayer: 创建一个 CAGradientLayer，设置渐变颜色、起始点、终点等属性，并添加到视图的子层。
 startSkeletonAnimation: 启动骨架层的动画，通过修改 gradientLayer 的 locations 属性来实现渐变动画效果。
 stopSkeletonAnimation: 停止骨架层的动画，并隐藏骨架层。
 链式调用部分

 ViewChainable 协议: 定义了一个空的协议，用于标记可以进行链式调用的类型。
 then 方法: 接受一个闭包作为参数，在闭包中对当前视图进行配置，并返回自身，从而实现链式调用。
 手势识别部分

 tapGesture 和 longPressGesture 属性: 使用 RxSwift 创建可观察序列，监听点击和长按手势。
 GestureTarget 类: 用于管理手势识别器和对应的事件处理。
 优点

 功能丰富: 提供了多种实用的功能，如骨架屏、链式调用、手势识别。
 代码简洁: 使用 RxSwift 简化了手势事件的处理。
 可扩展性强: 可以根据需求进一步扩展，添加更多的功能。
 使用场景

 骨架屏: 在数据加载过程中显示骨架屏，提升用户体验。
 链式调用: 简化视图的配置，提高代码可读性。
 手势交互: 实现点击、长按等交互功能。
 注意事项

 性能: 频繁创建和销毁 CAGradientLayer 可能影响性能，可以考虑复用。
 复杂手势: 对于更复杂的手势，可以考虑使用第三方库。
 RxSwift: 需要引入 RxSwift 和 RxCocoa 框架。
*/
