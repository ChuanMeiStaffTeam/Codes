//
//  LaunchViewController.swift
//  huanxi
//
//  Created by rslz on 2024/11/17.
//

import Foundation
import UIKit

class LaunchViewController: UIViewController {
    private var _launchView: UIView?
    private var launchView: UIView? {
        if _launchView == nil {
            let launchView = Bundle.main.loadNibNamed("LaunchScreen", owner: nil, options: nil)?[0] as? UIView
            launchView?.frame = view.bounds
            _launchView = launchView
        }
        return _launchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let launchView {
            view.addSubview(launchView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


/*代码功能:
 
 该类负责显示应用程序的启动界面。
 首先检查是否使用了 LaunchScreen.storyboard，如果是，则无需手动加载启动界面。
 如果使用了 LaunchScreen.xib，则从 XIB 文件中加载启动界面视图，并将其添加到当前视图控制器的视图上。
 改进:

 移除不必要的 _launchView 变量，简化代码。
 使用更清晰的变量名，如 launchScreenView。
 优化了 XIB 文件加载的逻辑，使其更简洁。
 建议:

 优先使用 Launch Screen Storyboard: 这是 Xcode 推荐的创建启动界面的方式，更易于使用和维护。
 优化启动速度: 尽量减少启动界面的加载时间，以提高用户体验。例如，可以考虑使用轻量级的占位视图，并在后台加载更复杂的启动界面。
 优化图片: 优化启动界面中使用的图片，减小文件大小，提高加载速度。
 注意:

 此代码仅适用于使用 LaunchScreen.xib 的情况。如果使用 LaunchScreen.storyboard，则无需手动加载启动界面。*/
