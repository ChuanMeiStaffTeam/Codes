//
//  SquareViewController.swift
//  huanxi
//
//  Created by rslz on 2025/1/20.
//

import UIKit
import SwiftUI
import Combine
import MJRefresh
import LCDSDK

class SquareViewController: UIViewController {
    
    lazy var videoVC: LCDDrawVideoViewController! = LCDDrawVideoViewController(configBuilder:{ (config:LCDDrawVideoVCConfig) in
        config.viewSize = CGSizeMake(UIScreen.main.bounds.width, UIScreen.main.bounds.height - UIDevice.sy_tabBarFullHeight)
        config.customAppear = true
        config.delegate = self
        config.adDelegate = self
//        config.livePreViewFeedAdExpressId = ""
//        config.livePreViewFeedAdNativeId = ""
    })
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sh_prefersNavigationBarHidden = true
        self.navigationController?.navigationBar.isHidden = true
        view.addSubview(videoVC.view)
        addChild(videoVC)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoVC.drawVideoViewControllerDidAppear()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        videoVC.drawVideoViewControllerDidDisappear()
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoVC.drawVideoViewControllerDidDisappear()
    }
    

    
    deinit {

    }
    
    
    func setupUI() {
        
        view.addSubview(videoVC.view)
        self.addChild(videoVC)
    }

    
    func bindUI() {
 
        
    }
    
//    /// 初始化小视频首页
//    func configVideoVC() -> LCDDrawVideoViewController! {
//        let videoVc:LCDDrawVideoViewController! = LCDDrawVideoViewController(configBuilder:{ (config:LCDDrawVideoVCConfig) in
//            config.viewSize = CGSizeMake(UIScreen.main.bounds.width, UIScreen.main.bounds.height - UIDevice.sy_tabBarFullHeight)
//            config.drawVCTabOptions = LCDDrawVideoVCTabOptions.recommand
//        })
//        videoVc.tabBarItem.title = "小视频"
//        videoVc.tabBarItem.image = UIImage(named: "video")
//        return videoVc
//    }
}



extension SquareViewController: LCDDrawVideoViewControllerDelegate, LCDAdvertCallBackProtocol {
    func lcdClickAdViewEvent(_ event: LCDAdTrackEvent) {
        
    }
}

/*代码功能：

这段代码定义了一个自定义的 UITableViewCell，名为 UpdatesRecommendCell，主要用于社交媒体应用中展示推荐关注的用户。它通常会出现在动态列表中，显示一些你可能感兴趣的用户信息。

主要功能点：

UI 布局: 使用 SnapKit 对 cell 内部的子视图（头像、昵称、内容文本、标签、关注按钮、关闭按钮）进行布局，使其在不同屏幕尺寸下都能保持良好的显示效果。
数据展示: 通过 reloadData 方法设置 cell 的内容，包括头像图片、用户昵称、推荐理由、标签（如热门）以及关注按钮和关闭按钮的状态。
交互功能: 提供了两个按钮：
followBtn: 用于关注或取消关注推荐用户。
closeBtn: 用于关闭该推荐项，不再显示。
这两个按钮都绑定了对应的闭包，以便在点击时触发相应的操作。
代码结构：

类名: UpdatesRecommendCell，明确表示这个类用于展示推荐的更新。
属性:
followBlock: 一个闭包，用于在点击关注按钮时执行自定义操作。
closeBlock: 一个闭包，用于在点击关闭按钮时执行自定义操作。
icon: 用于显示头像的 UIImageView。
nameLabel: 用于显示用户昵称的 UILabel。
contentLabel: 用于显示推荐理由的 UILabel。
tagLabel: 用于显示标签的 UILabel。
followBtn: 用于关注或取消关注的 UIButton。
closeBtn: 用于关闭推荐项的 UIButton。
方法:
init(style:reuseIdentifier:): 初始化方法，设置 cell 的样式和重用标识符。
reloadData：更新 cell 的内容，包括头像、内容和时间。
setupView: 配置 cell 的子视图，设置约束和样式。
followAction: 关注按钮的点击事件处理函数，触发 followBlock 回调。
closeAction: 关闭按钮的点击事件处理函数，触发 closeBlock 回调。
代码逻辑:

初始化: 创建 cell 时，会调用 setupView 方法来设置子视图的布局和样式。
更新数据: 当需要显示新的数据时，调用 reloadData 方法更新 cell 的内容。
显示内容: cell 的内容包括头像、昵称、推荐理由、标签、关注按钮和关闭按钮，这些信息通过对应的属性和约束来显示。
用户交互: 点击关注按钮或关闭按钮时，会触发相应的闭包，可以执行自定义的逻辑，比如发送网络请求、更新数据源等。
潜在改进:

数据源: 当前代码中，reloadData 方法直接硬编码了数据。在实际应用中，应该通过数据源来动态设置 cell 的内容。
自定义样式: 可以提供更多的自定义选项，比如允许用户自定义 cell 的外观。
性能优化: 如果有大量的数据需要展示，可以考虑使用异步加载图片、复用 cell 等方式来优化性能。
 可访问性: 考虑为视障用户提供更好的访问性，比如使用语义化的标签和设置适当的对比度。*/
