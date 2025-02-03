//
//  PostMorePopView.swift
//  huanxi
//
//  Created by rslz on 2024/12/17.
//

import Foundation
import Kingfisher
import RxCocoa
import RxSwift
import UIKit

class PostMorePopView: BaseView {
    var postModel: PostModel = PostModel(liked: false)

    var onDeleteTap: (()->Void)?
    var onBriefTap: (()->Void)?

    
    private let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        return view
    }()

    private let drawerView: DrawerView = {
        let view = DrawerView()
        view.accessibilityIdentifier = "PostMorePopView"
        view.backgroundColor = UIColor.postBgColor
        view.snapPositions = [.closed, .open]
        view.position = .open
        view.openHeightBehavior = .fixed(height: 150)
        view.cornerRadius = 20
        return view
    }()

    let trashButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.contentHorizontalAlignment = .left
        button.setTitle("删除", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "trash.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()

    let briefcaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .left
        button.setTitle("查看简介", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "briefcase.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()

    init() {
        super.init(frame: UIScreen.main.bounds)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        drawerView.delegate = self

        drawerView.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(40)
        }

        [trashButton, briefcaseButton].forEach({ $0.setImgPosition(postion: .Left, spacing: 10) })

        // 创建 UIStackView
        let stackView = UIStackView(arrangedSubviews: [trashButton, briefcaseButton])
        stackView.axis = .vertical // 纵向排列
        stackView.alignment = .fill // 子视图填充
        stackView.distribution = .fillEqually // 高度平均分配
        stackView.spacing = 16 // 按钮之间的间距
        stackView.isUserInteractionEnabled = true
        
        // 添加 StackView 到视图
        drawerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(topLine.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    
    }
    
    /*
    private func bindUI() {
        trashButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.drawerView.isConcealed = true
            if let block = self.onDeleteTap {
                  block()
            }
        }).disposed(by: disposeBag)
        
        briefcaseButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.drawerView.isConcealed = true
            if let block = self.onBriefTap {
                  block()
            }
        }).disposed(by: disposeBag)
    }
     */

    @objc func trashButtonTap() {
        self.drawerView.isConcealed = true
        if let block = self.onDeleteTap {
              block()
        }
    }
    
    func show(_ postModel: PostModel, type: Int = 0) {
        self.postModel = postModel
        if let userInfo = LoginManager.shared.getUserInfo() {
            trashButton.isHidden = postModel.userId != userInfo.userId
        }
        if type == 1 {
            briefcaseButton.isHidden = true
        }
        if let window = getKeyWindow() {
            drawerView.attachTo(view: window)
        }
    }
    
    func close() {
        self.drawerView.isConcealed = true
    }
}

extension PostMorePopView: DrawerViewDelegate {
    func drawerDidMove(_ drawerView: DrawerView, drawerOffset: CGFloat) {
    }

    func drawer(_ drawerView: DrawerView, didTransitionTo position: DrawerPosition) {
    }
    func drawer(_ drawerView: DrawerView, willTransitionFrom startPosition: DrawerPosition, to targetPosition: DrawerPosition) {
        if targetPosition == .closed {
        }
    }
}


/*代码分析：PostMorePopView.swift

功能概述

这段代码定义了一个名为 PostMorePopView 的自定义视图，这个视图通常用在社交媒体应用中，当用户点击帖子上的更多选项按钮时，会弹出一个包含多个选项的菜单。这个菜单提供了诸如删除帖子、查看更多信息等功能。

主要组成部分

UI 元素:
topLine: 一个顶部装饰线，用于美观。
drawerView: 一个可滑动的抽屉视图，包含了菜单选项。
trashButton 和 briefcaseButton: 两个按钮，分别用于删除帖子和查看更多信息。
属性:
postModel: 保存当前操作的帖子信息。
onDeleteTap 和 onBriefTap: 这两个闭包分别用于在点击删除和查看更多按钮时执行自定义操作。
方法:
setupUI: 初始化 UI 元素，设置布局。
show: 显示弹窗，并根据传入的 postModel 和 type 参数进行配置。
close: 关闭弹窗。
drawerDidMove, drawerDidTransitionTo, drawerWillTransitionFrom: 这些方法是 DrawerViewDelegate 的协议方法，用于处理抽屉视图的状态变化。
代码逻辑

初始化: 在 init 方法中，创建了 UI 元素并设置了基本的布局。
显示弹窗: show 方法用于显示弹窗。它会根据传入的 postModel 更新按钮的显示状态（比如，如果当前用户不是帖子作者，则隐藏删除按钮）。
用户交互: 按钮的点击事件会触发相应的闭包，从而执行删除、查看更多等操作。
抽屉动画: DrawerView 提供了抽屉动画效果，使得弹窗的显示和隐藏更加平滑。
关键点

自定义视图: PostMorePopView 是一个自定义视图，可以根据需求进行灵活定制。
抽屉效果: 使用 DrawerView 实现了一个抽屉式的弹窗效果。
数据绑定: 通过 postModel 将帖子信息与视图进行绑定。
闭包回调: 使用闭包来实现自定义的事件处理逻辑。
可能的问题和改进

代码可读性: 可以添加更多的注释来解释代码的意图，尤其是对于一些自定义的方法或属性。
错误处理: 可以添加一些错误处理，比如检查 postModel 是否为空等。
性能优化: 如果需要处理大量的数据，可以考虑一些性能优化措施。
可扩展性: 可以考虑将 trashButton 和 briefcaseButton 提取出来，作为一个数组进行管理，以便方便地添加更多的按钮。
总结

这段代码实现了一个功能相对简单的弹窗组件，用于显示帖子相关的操作选项。它使用了 SwiftUI 和一些第三方库来实现 UI 布局和动画效果。通过自定义这个组件，可以灵活地适配不同的应用场景。
 */
