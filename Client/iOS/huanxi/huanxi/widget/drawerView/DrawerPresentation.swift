//
//  DrawerPresentation.swift
//  Bussinavi
//
//  Created by Mikko Välimäki on 2019-11-24.
//
import UIKit

public protocol DrawerPresenter {
    func presentDrawerModal(_ presentedViewController: UIViewController, openHeightBehavior: DrawerView.OpenHeightBehavior)
}

extension UIViewController: DrawerPresenter {
    public func presentDrawerModal(_ presentedViewController: UIViewController, openHeightBehavior: DrawerView.OpenHeightBehavior) {

    }
}

public class DrawerPresentationController: UIPresentationController {

    private let drawerView: DrawerView

    private var presentationDelegate: DrawerPresentationDelegate?

    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         drawerView: DrawerView,
         presentationDelegate: DrawerPresentationDelegate?
    ) {
        self.drawerView = drawerView
        self.presentationDelegate = presentationDelegate
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override public var presentedView: UIView? {
        return drawerView
    }

    override public var presentationStyle: UIModalPresentationStyle {
        return .currentContext
    }

    override public func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = self.containerView else {
            return
        }

        presentedViewController.view.removeFromSuperview()
        drawerView.embed(view: presentedViewController.view)

        drawerView.position = .closed
        drawerView.snapPositions = [.open, .closed]
        drawerView.delegate = self

        drawerView.attachTo(view: containerView)
        drawerView.layoutIfNeeded()

        // Make callbacks backwards compatible
        if let callback = presentationDelegate?.drawerPresentationWillBegin(for:in:) {
            callback(presentedViewController, drawerView)
        } else {
            presentationDelegate?.drawerPresentationWillBegin?()
        }
    }

    public override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        // Make callbacks backwards compatible
        if let callback = presentationDelegate?.drawerPresentationDidEnd(for:in:completed:) {
            callback(presentedViewController, drawerView, completed)
        } else {
            presentationDelegate?.drawerPresentationDidEnd?(completed)
        }
    }

    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        // Make callbacks backwards compatible
        if let callback = presentationDelegate?.drawerDismissalWillBegin(for:in:) {
            callback(presentedViewController, drawerView)
        } else {
            presentationDelegate?.drawerDismissalWillBegin?()
        }
    }

    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)

        // Clean up the drawer for reuse.
        presentedViewController.view.removeFromSuperview()
        presentedViewController.removeFromParent()
        drawerView.removeFromSuperview()

        // Make callbacks backwards compatible
        if let callback = presentationDelegate?.drawerDismissalDidEnd(for:in:completed:) {
            callback(presentedViewController, drawerView, completed)
        } else {
            presentationDelegate?.drawerDismissalDidEnd?(completed)
        }
    }

    override public var shouldRemovePresentersView: Bool {
        return false
    }

    override public func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
    }
}

@objc public protocol DrawerPresentationDelegate {

    @available(*, deprecated, renamed: "drawerPresentationWillBegin(for:in:)")
    @objc optional func drawerPresentationWillBegin()
    @available(*, deprecated, renamed: "drawerPresentationDidEnd(for:in:completed:)")
    @objc optional func drawerPresentationDidEnd(_ completed: Bool)
    @available(*, deprecated, renamed: "drawerDismissalWillBegin(for:in:)")
    @objc optional func drawerDismissalWillBegin()
    @available(*, deprecated, renamed: "drawerDismissalDidEnd(for:in:completed:)")
    @objc optional func drawerDismissalDidEnd(_ completed: Bool)

    @objc optional func drawerPresentationWillBegin(for viewController: UIViewController, in drawerView: DrawerView)
    @objc optional func drawerPresentationDidEnd(for viewController: UIViewController, in drawerView: DrawerView, completed: Bool)
    @objc optional func drawerDismissalWillBegin(for viewController: UIViewController, in drawerView: DrawerView)
    @objc optional func drawerDismissalDidEnd(for viewController: UIViewController, in drawerView: DrawerView, completed: Bool)

}

extension DrawerPresentationController: DrawerViewDelegate {

    public func drawer(_ drawerView: DrawerView, willTransitionFrom startPosition: DrawerPosition, to targetPosition: DrawerPosition) {
        if targetPosition == .closed {
            presentedViewController.dismiss(animated: true)
        }
    }
}

public class DrawerPresentationManager: NSObject {
    public var drawer = DrawerView()

    public var presentationDelegate: DrawerPresentationDelegate?
}

extension DrawerPresentationManager: UIViewControllerTransitioningDelegate {

    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let presentationController = DrawerPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            drawerView: self.drawer,
            presentationDelegate: self.presentationDelegate
        )
        return presentationController
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DrawerPresentationAnimator(presentation: .present)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DrawerPresentationAnimator(presentation: .dismiss)
    }
}

public final class DrawerPresentationAnimator: NSObject {

    let presentation: PresentationType

    enum PresentationType {
      case present
      case dismiss
    }

    init(presentation: PresentationType) {
        self.presentation = presentation
        super.init()
    }
}

extension DrawerPresentationAnimator: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return 0.0
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        switch presentation {
        case .present:
            guard let drawerView = transitionContext.view(forKey: .to) as? DrawerView else {
                return
            }

            drawerView.setPosition(.open, animated: true) { finished in
               transitionContext.completeTransition(finished)
           }
        case .dismiss:
            guard let drawerView = transitionContext.view(forKey: .from) as? DrawerView else {
                return
            }
            drawerView.setPosition(.closed, animated: true) { finished in
                transitionContext.completeTransition(finished)
            }
        }
    }
}
/*代码功能：

这段 Swift 代码实现了一个自定义的 UILabel 子类，名为 RichTextLabel，其主要功能是：

富文本显示： 可以设置带有不同样式（如颜色、下划线）的文本。
点击事件处理： 可以为文本中的特定部分设置点击事件，当用户点击这些部分时，会触发相应的回调。
代码实现细节：

tapRanges 属性： 用来存储文本中各个可点击部分的范围、文本内容和颜色信息。
setRichText 方法：
创建一个 NSMutableAttributedString 对象，设置初始属性。
遍历 tapStyles 数组，找到每个需要设置点击样式的子字符串，并设置其属性（颜色、下划线）。
将找到的可点击部分的范围、文本内容和颜色信息添加到 tapRanges 数组中。
将最终的富文本赋值给 attributedText 属性。
handleTap 方法：
当用户点击标签时，会触发该方法。
通过 location 获取点击的位置。
调用 getTappedString(at:) 方法，根据点击位置查找对应的可点击部分。
如果找到了，则调用 onTextTapped 回调函数，将点击的文本、范围和索引传递给外部。
getTappedString(at:) 方法：
使用 NSTextStorage、NSLayoutManager 和 NSTextContainer 来计算点击位置对应的字符索引。
遍历 tapRanges 数组，查找点击位置是否在某个可点击部分的范围内。
如果找到，则返回对应的子字符串、范围和索引。
代码作用：

这个自定义的 UILabel 子类可以用来实现一些常见的富文本功能，比如：

超链接： 点击带下划线的文本时，可以跳转到指定的页面或执行其他操作。
自定义按钮： 在文本中嵌入可点击的按钮。
文本高亮： 突出显示文本中的某些部分。
使用场景：

新闻阅读类应用： 显示包含链接的新闻文章。
社交媒体应用： 显示包含@提及、#话题等可点击元素的文本。
聊天应用： 实现表情、图片等富文本功能。*/
