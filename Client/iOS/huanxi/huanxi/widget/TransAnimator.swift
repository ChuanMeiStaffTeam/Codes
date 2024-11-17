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

