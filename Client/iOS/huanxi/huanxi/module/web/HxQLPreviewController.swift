//
//  HxQLPreviewController.swift
//  huanxi
//
//  Created by rslz on 2024/12/3.
//

import Foundation
import UIKit
import QuickLook

class HxQLPreviewController: QLPreviewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftButton = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(leftButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
        setupBaseView()
    }
    
    func setupBaseView() {
        view.backgroundColor = .white
    }
    
    
    // 按钮点击事件
    @objc func leftButtonTapped() {
        if let navigationController = self.navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

/*代码分析：HxQLPreviewController
 功能概述

 这段代码定义了一个名为 HxQLPreviewController 的类，继承自 QLPreviewController。它的主要作用是提供一个快速预览各种文档的视图控制器。

 核心功能

 初始化和配置:

 在 viewDidLoad 方法中，设置了导航栏的返回按钮，方便用户返回上一层。
 调用 setupBaseView 方法进行一些基本的视图设置，比如设置背景颜色。
 预览文档:

 继承自 QLPreviewController，因此可以直接利用其强大的预览功能。
 通过设置 dataSource 属性，可以指定要预览的文件或数据。
 代码解读

 leftButtonTapped 方法:
 实现返回按钮的点击事件。
 根据当前视图控制器的嵌套方式，决定是弹出还是返回上一级页面。
 setupBaseView 方法:
 目前仅设置了背景颜色，可以根据需要添加其他视图配置。
 代码优点

 简洁高效: 利用 QLPreviewController 提供的强大功能，快速实现文档预览。
 可扩展性强: 可以通过自定义 dataSource 来支持各种类型的文档预览。
 易于使用: 只需设置 dataSource 属性即可实现预览功能。
 潜在改进

 自定义外观: 可以通过自定义 QLPreviewController 的外观来满足不同的设计需求。
 错误处理: 可以添加错误处理，例如当无法预览文档时提示用户。
 进度指示: 对于较大的文件，可以显示加载进度。
 交互功能: 可以添加一些交互功能，例如缩放、旋转等。
 支持更多文件类型: 可以通过自定义 QLPreviewItem 来支持更多类型的文件。
*/
