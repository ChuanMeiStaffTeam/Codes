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
