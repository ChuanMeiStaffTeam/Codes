// The MIT License (MIT)
//
//  Copyright © 2017年 ShowHandAce
//

/**
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit

open class SHFullscreenPopGesture {
    
    open class func configure() {
        
        UINavigationController.sh_nav_initialize()
        UIViewController.sh_initialize()
    }
    
}

extension UINavigationController {
    
    private var sh_popGestureRecognizerDelegate: _SHFullscreenPopGestureRecognizerDelegate {
        guard let delegate = objc_getAssociatedObject(self, RuntimeKey.KEY_sh_popGestureRecognizerDelegate!) as? _SHFullscreenPopGestureRecognizerDelegate else {
            let popDelegate = _SHFullscreenPopGestureRecognizerDelegate()
            popDelegate.navigationController = self
            objc_setAssociatedObject(self, RuntimeKey.KEY_sh_popGestureRecognizerDelegate!, popDelegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return popDelegate
        }
        return delegate
    }
    
    @objc open class func sh_nav_initialize() {
        // Inject "-pushViewController:animated:"
        DispatchQueue.once(token: "com.UINavigationController.MethodSwizzling", block: {
            let originalMethod = class_getInstanceMethod(self, #selector(pushViewController(_:animated:)))
            let swizzledMethod = class_getInstanceMethod(self, #selector(sh_pushViewController(_:animated:)))
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        })
    }
    
//    override open class func initialize() {
//        // Inject "-pushViewController:animated:"
//        DispatchQueue.once(token: "com.UINavigationController.MethodSwizzling", block: {
//            let originalMethod = class_getInstanceMethod(self, #selector(pushViewController(_:animated:)))
//            let swizzledMethod = class_getInstanceMethod(self, #selector(sh_pushViewController(_:animated:)))
//            method_exchangeImplementations(originalMethod!, swizzledMethod!)
//        })
//    }
    
    @objc private func sh_pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.interactivePopGestureRecognizer?.view?.gestureRecognizers?.contains(self.sh_fullscreenPopGestureRecognizer) == false {
            
            // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
            self.interactivePopGestureRecognizer?.view?.addGestureRecognizer(self.sh_fullscreenPopGestureRecognizer)
            
            // Forward the gesture events to the private handler of the onboard gesture recognizer.
            let internalTargets = self.interactivePopGestureRecognizer?.value(forKey: "targets") as? Array<NSObject>
            let internalTarget = internalTargets?.first?.value(forKey: "target")
            let internalAction = NSSelectorFromString("handleNavigationTransition:")
            if let target = internalTarget {
                self.sh_fullscreenPopGestureRecognizer.delegate = self.sh_popGestureRecognizerDelegate
                self.sh_fullscreenPopGestureRecognizer.addTarget(target, action: internalAction)
                
                // Disable the onboard gesture recognizer.
                self.interactivePopGestureRecognizer?.isEnabled = false
            }
        }
        
        // Handle perferred navigation bar appearance.
        self.sh_setupViewControllerBasedNavigationBarAppearanceIfNeeded(viewController)
        
        // Forward to primary implementation.
        self.sh_pushViewController(viewController, animated: animated)
    }
    
    private func sh_setupViewControllerBasedNavigationBarAppearanceIfNeeded(_ appearingViewController: UIViewController) {
        
        if !self.sh_viewControllerBasedNavigationBarAppearanceEnabled {
            return
        }
        
        let blockContainer = _SHViewControllerWillAppearInjectBlockContainer() { [weak self] (_ viewController: UIViewController, _ animated: Bool) -> Void in
            self?.setNavigationBarHidden(viewController.sh_prefersNavigationBarHidden, animated: animated)
        }
        
        // Setup will appear inject block to appearing view controller.
        // Setup disappearing view controller as well, because not every view controller is added into
        // stack by pushing, maybe by "-setViewControllers:".
        appearingViewController.sh_willAppearInjectBlockContainer = blockContainer
        let disappearingViewController = self.viewControllers.last
        if let vc = disappearingViewController {
            if vc.sh_willAppearInjectBlockContainer == nil {
                vc.sh_willAppearInjectBlockContainer = blockContainer
            }
        }
    }
    
    /// The gesture recognizer that actually handles interactive pop.
    public var sh_fullscreenPopGestureRecognizer: UIPanGestureRecognizer {
        guard let pan = objc_getAssociatedObject(self, RuntimeKey.KEY_sh_fullscreenPopGestureRecognizer!) as? UIPanGestureRecognizer else {
            let panGesture = UIPanGestureRecognizer()
            panGesture.maximumNumberOfTouches = 1;
            objc_setAssociatedObject(self, RuntimeKey.KEY_sh_fullscreenPopGestureRecognizer!, panGesture, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return panGesture
        }
        return pan
    }
    
    /// A view controller is able to control navigation bar's appearance by itself,
    /// rather than a global way, checking "fd_prefersNavigationBarHidden" property.
    /// Default to true, disable it if you don't want so.
    public var sh_viewControllerBasedNavigationBarAppearanceEnabled: Bool {
        get {
            guard let bools = objc_getAssociatedObject(self, RuntimeKey.KEY_sh_viewControllerBasedNavigationBarAppearanceEnabled!) as? Bool else {
                self.sh_viewControllerBasedNavigationBarAppearanceEnabled = true
                return true
            }
            return bools
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.KEY_sh_viewControllerBasedNavigationBarAppearanceEnabled!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

fileprivate typealias _SHViewControllerWillAppearInjectBlock = (_ viewController: UIViewController, _ animated: Bool) -> Void

fileprivate class _SHViewControllerWillAppearInjectBlockContainer {
    var block: _SHViewControllerWillAppearInjectBlock?
    init(_ block: @escaping _SHViewControllerWillAppearInjectBlock) {
        self.block = block
    }
}

extension UIViewController {
    
    fileprivate var sh_willAppearInjectBlockContainer: _SHViewControllerWillAppearInjectBlockContainer? {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.KEY_sh_willAppearInjectBlockContainer!) as? _SHViewControllerWillAppearInjectBlockContainer
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.KEY_sh_willAppearInjectBlockContainer!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc open class func sh_initialize() {
        
        DispatchQueue.once(token: "com.UIViewController.MethodSwizzling", block: {
            let originalMethod = class_getInstanceMethod(self, #selector(viewWillAppear(_:)))
            let swizzledMethod = class_getInstanceMethod(self, #selector(sh_viewWillAppear(_:)))
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        })
    }
    
//    override open class func initialize() {
//
//        DispatchQueue.once(token: "com.UIViewController.MethodSwizzling", block: {
//            let originalMethod = class_getInstanceMethod(self, #selector(viewWillAppear(_:)))
//            let swizzledMethod = class_getInstanceMethod(self, #selector(sh_viewWillAppear(_:)))
//            method_exchangeImplementations(originalMethod!, swizzledMethod!)
//        })
//    }
    
    @objc private func sh_viewWillAppear(_ animated: Bool) {
        // Forward to primary implementation.
        self.sh_viewWillAppear(animated)
        
        if let block = self.sh_willAppearInjectBlockContainer?.block {
            block(self, animated)
        }
    }
    
    /// Whether the interactive pop gesture is disabled when contained in a navigation stack.
    public var sh_interactivePopDisabled: Bool {
        get {
            guard let bools = objc_getAssociatedObject(self, RuntimeKey.KEY_sh_interactivePopDisabled!) as? Bool else {
                return false
            }
            return bools
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.KEY_sh_interactivePopDisabled!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// Indicate this view controller prefers its navigation bar hidden or not,
    /// checked when view controller based navigation bar's appearance is enabled.
    /// Default to false, bars are more likely to show.
    public var sh_prefersNavigationBarHidden: Bool {
        get {
            guard let bools = objc_getAssociatedObject(self, RuntimeKey.KEY_sh_prefersNavigationBarHidden!) as? Bool else {
                return false
            }
            return bools
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.KEY_sh_prefersNavigationBarHidden!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// Max allowed initial distance to left edge when you begin the interactive pop
    /// gesture. 0 by default, which means it will ignore this limit.
    public var sh_interactivePopMaxAllowedInitialDistanceToLeftEdge: Double {
        get {
            guard let doubleNum = objc_getAssociatedObject(self, RuntimeKey.KEY_sh_interactivePopMaxAllowedInitialDistanceToLeftEdge!) as? Double else {
                return 0.0
            }
            return doubleNum
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.KEY_sh_interactivePopMaxAllowedInitialDistanceToLeftEdge!, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
}

private class _SHFullscreenPopGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    
    weak var navigationController: UINavigationController?
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard let navigationC = self.navigationController else {
            return false
        }
        
        // Ignore when no view controller is pushed into the navigation stack.
        guard navigationC.viewControllers.count > 1 else {
            return false
        }
        
        // Disable when the active view controller doesn't allow interactive pop.
        guard let topViewController = navigationC.viewControllers.last else {
            return false
        }
        guard !topViewController.sh_interactivePopDisabled else {
            return false
        }
        
        // Ignore pan gesture when the navigation controller is currently in transition.
        guard let trasition = navigationC.value(forKey: "_isTransitioning") as? Bool else {
            return false
        }
        guard !trasition else {
            return false
        }
        
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        
        // Ignore when the beginning location is beyond max allowed initial distance to left edge.
        let beginningLocation = panGesture.location(in: panGesture.view)
        let maxAllowedInitialDistance = topViewController.sh_interactivePopMaxAllowedInitialDistanceToLeftEdge
        guard maxAllowedInitialDistance <= 0 || Double(beginningLocation.x) <= maxAllowedInitialDistance else {
            return false
        }
        
        // Prevent calling the handler when the gesture begins in an opposite direction.
        let translation = panGesture.translation(in: panGesture.view)
        guard translation.x > 0 else {
            return false
        }
        
        return true
    }
}

fileprivate struct RuntimeKey {
    static let KEY_sh_willAppearInjectBlockContainer
        = UnsafeRawPointer(bitPattern: "KEY_sh_willAppearInjectBlockContainer".hashValue)
    static let KEY_sh_interactivePopDisabled
        = UnsafeRawPointer(bitPattern: "KEY_sh_interactivePopDisabled".hashValue)
    static let KEY_sh_prefersNavigationBarHidden
        = UnsafeRawPointer(bitPattern: "KEY_sh_prefersNavigationBarHidden".hashValue)
    static let KEY_sh_interactivePopMaxAllowedInitialDistanceToLeftEdge
        = UnsafeRawPointer(bitPattern: "KEY_sh_interactivePopMaxAllowedInitialDistanceToLeftEdge".hashValue)
    static let KEY_sh_fullscreenPopGestureRecognizer
        = UnsafeRawPointer(bitPattern: "KEY_sh_fullscreenPopGestureRecognizer".hashValue)
    static let KEY_sh_popGestureRecognizerDelegate
        = UnsafeRawPointer(bitPattern: "KEY_sh_popGestureRecognizerDelegate".hashValue)
    static let KEY_sh_viewControllerBasedNavigationBarAppearanceEnabled
        = UnsafeRawPointer(bitPattern: "KEY_sh_viewControllerBasedNavigationBarAppearanceEnabled".hashValue)
    static let KEY_sh_scrollViewPopGestureRecognizerEnable
        = UnsafeRawPointer(bitPattern: "KEY_sh_scrollViewPopGestureRecognizerEnable".hashValue)
}

extension UIScrollView: @retroactive UIGestureRecognizerDelegate {
    
    public var sh_scrollViewPopGestureRecognizerEnable: Bool {
        get {
            guard let bools = objc_getAssociatedObject(self, RuntimeKey.KEY_sh_scrollViewPopGestureRecognizerEnable!) as? Bool else {
                return false
            }
            return bools
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.KEY_sh_scrollViewPopGestureRecognizerEnable!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    //UIGestureRecognizerDelegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.sh_scrollViewPopGestureRecognizerEnable, self.contentOffset.x <= 0, let gestureDelegate = otherGestureRecognizer.delegate {
            if gestureDelegate.isKind(of: _SHFullscreenPopGestureRecognizerDelegate.self) {
                return true
            }
        }
        return false
    }
}

fileprivate extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

/*代码功能:

实现全屏侧滑返回手势: 该代码实现了一个自定义的导航栏全屏侧滑返回手势。
支持自定义配置: 允许开发者配置是否启用、是否支持与滚动视图的冲突处理等。
基于运行时机制: 使用运行时机制动态地替换导航控制器的 pushViewController 方法，以集成自定义手势。
支持自定义导航栏外观: 允许子视图控制器控制导航栏的显示与隐藏。
代码原理:

创建自定义手势: 创建一个 UIPanGestureRecognizer，用于处理全屏侧滑手势。
替换方法: 使用运行时机制替换 UINavigationController 的 pushViewController(_:animated:) 方法，在其中添加自定义手势逻辑。
处理手势: 在手势处理方法中判断手势的有效性，并转发给系统自带的手势处理方法。
自定义导航栏外观: 允许子视图控制器通过 sh_prefersNavigationBarHidden 属性控制导航栏的显示与隐藏。
与滚动视图冲突处理: 通过 UIScrollViewDelegate 方法，处理与滚动视图的冲突，避免误触发手势。
主要类和方法:

SHFullscreenPopGesture:
configure()： 初始化方法，用于配置手势。
UINavigationController:
sh_nav_initialize()： 替换 pushViewController(_:animated:) 方法。
sh_pushViewController(_:animated:)： 自定义的 pushViewController 方法，添加手势处理逻辑。
sh_fullscreenPopGestureRecognizer： 获取自定义的手势对象。
sh_viewControllerBasedNavigationBarAppearanceEnabled： 是否启用基于视图控制器的导航栏外观控制。
UIViewController:
sh_viewWillAppear(_:)： 在视图控制器即将显示时，检查并设置导航栏的隐藏状态。
sh_prefersNavigationBarHidden： 视图控制器是否希望隐藏导航栏。
sh_interactivePopDisabled： 是否禁用交互式返回手势。
_SHFullscreenPopGestureRecognizerDelegate:
gestureRecognizerShouldBegin(_:)： 判断手势是否应该开始。
使用方式:

在 AppDelegate 或者其他合适的入口处调用 SHFullscreenPopGesture.configure()。
在需要自定义导航栏外观的视图控制器中，设置 sh_prefersNavigationBarHidden 属性。
优点:

增强交互性: 提供了更自然、全屏的返回手势体验。
灵活性: 支持多种自定义配置，如禁用手势、自定义导航栏外观等。
兼容性: 兼容多个 iOS 版本。
注意:

该代码使用了运行时机制，需要谨慎使用，避免出现不可预期的后果。
需要注意与其他手势之间的冲突，尤其是与滚动视图的手势冲突。
改进建议:

可以添加更多配置选项，例如手势触发区域、手势速度等。
可以优化手势处理逻辑，提高流畅性。
可以添加更多注释，提高代码的可读性。*/
