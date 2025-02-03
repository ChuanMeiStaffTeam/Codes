//
//  ChatUserHomeViewController.swift
//  huanxi
//
//  Created by Jack on 2024/6/14.
//

import UIKit

class ChatUserHomeViewController: BaseViewController {
    
    lazy var mineHeader = MineHeaderView(type: .mySelf)

    var constrainerView: MineConstrainerView!

    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    func setupView() {
        title = "用户首页"
        
        let addButton = UIButton(type: .custom)
        addButton.setImage(UIImage(named: "main_snapshot_add"), for: .normal)
        addButton.frame = CGRect(x: .screenWidth - 80, y: .topSafeAreaHeight + 5, width: 30, height:30)
        addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        let item1 = UIBarButtonItem.init(customView: addButton)
        
        let setButton = UIButton(type: .custom)
        setButton.setImage(UIImage(named: "main_more"), for: .normal)
        setButton.frame = CGRect(x: .screenWidth - 40, y: .topSafeAreaHeight + 5, width: 30, height: 30)
        setButton.addTarget(self, action: #selector(setAction), for: .touchUpInside)
        let item2 = UIBarButtonItem.init(customView: setButton)

        navigationItem.rightBarButtonItems = [item1, item2]
        
        view.addSubview(mineHeader)
        mineHeader.editHomePageBlock = {
            let vc = EditProfileVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        constrainerView = MineConstrainerView(frame: CGRect.init(x: 0, y: mineHeader.bottom, width: .screenWidth, height: .screenHeight - mineHeader.bottom))
        view.addSubview(constrainerView)
    }
    
    
    @objc func addAction() {
        
    }
    
    @objc func setAction() {
        
    }
    
}


/*代码功能

这段代码实现了一个用户主页视图控制器 (ChatUserHomeViewController)，用于展示当前用户的个人信息和相关内容。

主要功能包括：

展示用户信息： 通过 MineHeaderView 显示用户的头像、昵称、简介等信息。
编辑用户信息： 提供编辑用户信息的功能，点击编辑按钮跳转到编辑页面。
导航栏按钮： 在导航栏右侧添加 "添加" 和 "设置" 按钮，但目前功能未实现。
代码结构

ChatUserHomeViewController 类：
属性：
mineHeader：用于展示用户信息的头部视图。
constrainerView：用于约束子视图的布局。
方法：
viewDidLoad：初始化视图，设置导航栏，添加子视图。
setupView：设置视图的布局，添加导航栏按钮，设置头部视图的回调。
addAction：处理 "添加" 按钮的点击事件（目前为空）。
setAction：处理 "设置" 按钮的点击事件（目前为空）。
代码分析

视图层次：
顶部是 mineHeader，用于展示用户信息。
紧随其后的是 constrainerView，用于约束其他子视图的布局。
导航栏：
右侧添加了两个按钮："添加" 和 "设置"，但目前功能未实现。
用户交互：
点击 mineHeader 中的编辑按钮，跳转到 EditProfileVC 页面。
改进建议

实现导航栏按钮功能： 完善 "添加" 和 "设置" 按钮的功能，例如：
"添加"：可以跳转到发布动态、添加好友等页面。
"设置"：可以跳转到用户设置页面，如修改密码、隐私设置等。
加载用户信息： 从网络或本地数据源加载用户信息，并更新 mineHeader 的显示。
添加子视图： 在 constrainerView 中添加其他子视图，例如：
用户动态列表
用户关注列表
用户粉丝列表
优化布局： 使用 Auto Layout 或 SnapKit 优化视图的布局，提高代码的可读性和可维护性。
添加动画效果： 添加一些动画效果，提高用户体验。

总结

 这段代码实现了用户主页视图的基本框架，但仍有很多可以改进的地方。通过完善功能、优化布局、添加动画效果等，可以打造一个更加完善的用户主页。*/
