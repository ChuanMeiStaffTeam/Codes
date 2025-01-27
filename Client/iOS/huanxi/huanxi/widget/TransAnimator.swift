//
//  TransAnimator.swift
//  huanxi
//
//  Created by rslz on 2024/11/17.
//

import UIKit

typealias ShadowClickBlock = () -> Void

class TransAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, UIGestureRecognizerDelegate {
    var shadowView: UIView?
    var isDismiss: Bool = false
    var shadowClickBlock: ShadowClickBlock?
    
    // MARK: - UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isDismiss = false
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isDismiss = true
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.01
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        if !isDismiss {
            // Present animation
            if shadowView == nil {
                shadowView = UIView()
                shadowView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shadowClick(_:))))
                shadowView?.backgroundColor = UIColor(white: 1, alpha: 0)
            }
            
            shadowView?.frame = containerView.bounds
            shadowView?.addSubview(toViewController.view)
            containerView.addSubview(shadowView!)
            
            let lastBounds = toViewController.view.bounds
            toViewController.view.center = shadowView?.center ?? CGPoint.zero
            toViewController.view.bounds = CGRect(x: 0, y: 0, width: 0, height: 0)
            
            if toViewController.modalPresentationStyle == .custom {
                fromViewController.beginAppearanceTransition(false, animated: true)
            }
            
            UIView.animate(withDuration: duration, animations: {
                toViewController.view.bounds = lastBounds
                self.shadowView?.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
            }, completion: { finished in
                if toViewController.modalPresentationStyle == .custom {
                    fromViewController.endAppearanceTransition()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else {
            // Dismiss animation
            containerView.bringSubviewToFront(fromViewController.view)
            
            if fromViewController.modalPresentationStyle == .custom {
                toViewController.beginAppearanceTransition(true, animated: true)
            }
            
            UIView.animate(withDuration: duration, animations: {
                fromViewController.view.bounds = CGRect(x: 0, y: 0, width: 0, height: 0)
                self.shadowView?.backgroundColor = UIColor(white: 1, alpha: 0)
            }, completion: { finished in
                fromViewController.view.removeFromSuperview()
                self.shadowView?.removeFromSuperview()
                self.shadowView = nil
                
                if fromViewController.modalPresentationStyle == .custom {
                    toViewController.endAppearanceTransition()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
    
    // MARK: - Gesture Recognizer Delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == shadowView
    }
    
    @objc private func shadowClick(_ sender: UITapGestureRecognizer) {
        shadowClickBlock?()
    }
}

/*
这个 TransAnimator 类似乎是一个自定义的动画控制器，用于实现视图控制器之间的过渡动画。它可能被用于实现一些特殊的转场效果，比如模态视图的弹出和消失。

代码功能分析（初步）：

isDismiss 属性： 用于区分是呈现动画还是消失动画。
shadowView 属性： 可能是一个用于遮罩的视图，在动画过程中会发生变化。
animationController(forPresented:presenting:source:) 和 animationController(forDismissed:dismissed:) 方法： 这是 UIViewControllerTransitioningDelegate 协议中的方法，用于返回自定义的动画控制器。
animateTransition(using:) 方法： 这是 UIViewControllerAnimatedTransitioning 协议中的方法，用于实现具体的动画逻辑。
可能的动画效果：

根据代码中的部分逻辑，可以推测这个动画控制器可能实现了以下效果：

遮罩效果： 使用 shadowView 在视图切换时创建一个遮罩层。
缩放效果： 通过改变 toViewController.view 的 bounds 来实现缩放效果。
自定义手势： 通过 shadowClick 方法处理点击手势，可能用于实现自定义的关闭动画。
需要进一步分析的部分：

shadowClickBlock 的作用： 这个闭包的作用是什么？在什么情况下会被调用？
动画的具体细节： 动画的时长、缓动函数、以及其他动画参数是如何设置的？
视图层次结构： 在动画过程中，视图的层次结构是如何变化的？*/
