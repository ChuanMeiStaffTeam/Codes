//
//  LaunchManager.swift
//  huanxi
//
//  Created by rslz on 2024/11/17.
//

import UIKit

// 类型别名
typealias LaunchHandler = () -> Void
typealias LaunchAdHandler = () -> Void

class LaunchManager {
    // 单例
    static let shared = LaunchManager()

    // 属性
    private var launchHandler: LaunchHandler?
    private var launchAdHandler: LaunchAdHandler?
    private let animator: TransAnimator = TransAnimator()
    private var launchViewController: LaunchViewController = LaunchViewController()
    private let launchWindow: UIWindow = {
        var window: UIWindow
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        window.windowLevel = .alert
        return window
    }()

    // 禁止外部实例化
    private init() {}

    // 配置方法
    func configLaunchHandler(_ handler: @escaping LaunchHandler, adHandler: @escaping LaunchAdHandler) {
        launchWindow.rootViewController = launchViewController
        launchWindow.makeKeyAndVisible()

        // 检查是否同意隐私协议
        if !UserDefaults.standard.bool(forKey: "PrivacyAccepted") {
            DispatchQueue.main.async {
                let privacyPopup = PrivacyPopupViewController()
                privacyPopup.modalPresentationStyle = .overFullScreen
                privacyPopup.transitioningDelegate = self.animator
                privacyPopup.onAgreeTap = { [weak self] in
                    guard let strongSelf = self else { return }
                    handler()
                    strongSelf.dismissLaunchWindow()
                    UserDefaults.standard.set(true, forKey: "PrivacyAccepted")
                }
                self.launchViewController.present(privacyPopup, animated: true, completion: nil)
            }
            return
        }

        configGuidePageView(handler: handler, adHandler: adHandler)
    }

    // 关闭启动窗口
    func dismissLaunchWindow() {
        launchWindow.resignKey()
        launchWindow.alpha = 0
        launchWindow.removeFromSuperview()
    }

    // 配置引导页视图
    private func configGuidePageView(handler: @escaping LaunchHandler, adHandler: @escaping LaunchAdHandler) {
        launchHandler = handler
        launchAdHandler = adHandler
        // 显示引导页
        
        
        if let block = launchHandler {
            block()
            dismissLaunchWindow()
        }
        
    }

    // 保存版本信息
    private func saveBuildVersion() {
        let key = kCFBundleVersionKey as String
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: key) as? String
        UserDefaults.standard.setValue(currentVersion, forKey: key)
        UserDefaults.standard.synchronize()
    }

}

/*功能: 该类负责管理应用程序的启动流程，包括隐私协议弹窗、引导页展示、以及启动后执行的回调。
 单例模式: 使用 static let shared 实现单例模式，确保只有一个 LaunchManager 实例。
 启动流程:
 检查用户是否已同意隐私协议：
 如果未同意，则显示 PrivacyPopupViewController，并在用户同意后继续启动流程。
 显示引导页（如果需要）：
 调用 configGuidePageView 方法，该方法负责显示引导页并执行后续操作。
 执行启动回调：
 调用 launchHandler 回调，通知应用程序启动完成。
 其他功能:
 创建并管理启动窗口。
 保存应用程序版本信息。
 改进建议:

 引导页逻辑:
 当前代码直接调用 launchHandler，意味着没有实际的引导页展示逻辑。应该添加引导页的展示逻辑，例如：
 创建一个 GuidePageViewController 类来管理引导页的展示。
 使用 UIPageViewController 或者其他方式实现引导页的滑动切换。
 在引导页结束后调用 launchHandler。
 隐私协议弹窗:
 可以考虑将 PrivacyPopupViewController 的创建和展示逻辑封装到 LaunchManager 内部，提高模块化。
 可以添加对不同场景（首次启动、版本更新等）的处理。
 版本更新检查:
 可以添加版本更新检查逻辑，在启动时检查是否有新版本可用，并提示用户更新。
 错误处理:
 可以添加对可能出现的错误进行处理，例如隐私协议弹窗展示失败、引导页加载失败等。
 可测试性:
 考虑增加单元测试来验证 LaunchManager 的各个功能。*/
