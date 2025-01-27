//
//  LoadMoreControl.swift
//  Douyin
//
//  Created by Qiao Shi on 2018/8/5.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

import Foundation
import UIKit

typealias OnLoad = () -> Void

class LoadMoreControl: UIControl {

    var indicator: UIImageView = UIImageView.init(
        image: UIImage.init(named: "icon_loading_w_small"))
    var label: UILabel = UILabel.init()

    var surplusCount: Int = 0
    var originalFrame: CGRect = .zero
    var superView: UIScrollView?
    var edgeInsets: UIEdgeInsets?

    private var _onLoad: OnLoad?
    var onLoad: OnLoad? {
        set {
            _onLoad = newValue
        }
        get {
            return _onLoad
        }
    }

    private var _loadingType: LoadingType = .LoadStateIdle
    var loadingType: LoadingType {
        set {
            _loadingType = newValue
            switch newValue {
            case .LoadStateIdle:
                self.isHidden = true
                break
            case .LoadStateLoading:
                self.isHidden = false
                indicator.isHidden = false
                label.text = "内容加载中..."
                label.snp.makeConstraints { make in
                    make.centerY.equalTo(self)
                    make.centerX.equalTo(self).offset(20)
                }
                indicator.snp.makeConstraints { make in
                    make.centerY.equalTo(self)
                    make.right.equalTo(self.label.snp.left).inset(-5)
                    make.width.height.equalTo(15)
                }
                DispatchQueue.main.asyncAfter(
                    deadline: DispatchTime.now() + 0.1,
                    execute: {
                        self.startAnim()
                    })
                break
            case .LoadStateAll:
                self.isHidden = false
                indicator.isHidden = true
                label.text = "没有更多了哦～"
                label.snp.makeConstraints { make in
                    make.center.equalTo(self)
                }
                stopAnim()
                updateFrame()
                break
            case .LoadStateFailed:
                self.isHidden = false
                indicator.isHidden = true
                label.text = "加载更多"
                label.snp.makeConstraints { make in
                    make.center.equalTo(self)
                }
                stopAnim()
                break
            }
        }
        get {
            return _loadingType
        }
    }

    init(frame: CGRect, surplusCount: Int) {
        super.init(frame: frame)
        self.surplusCount = surplusCount
        self.originalFrame = frame
        initSubView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.originalFrame = frame
        initSubView()
    }

    func initSubView() {
        self.layer.zPosition = -1
        indicator.isHidden = true
        self.addSubview(indicator)

        label.text = "正在加载..."
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textAlignment = .center
        self.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        superView = self.superview as? UIScrollView
        if edgeInsets == nil {
            edgeInsets = self.superView?.contentInset
            edgeInsets?.bottom += (50 + CGFloat.bottomSafeAreaHeight)
            self.superView?.contentInset = edgeInsets ?? .zero
            superView?.addObserver(
                self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }

    func cellNumInTableView(tableView: UITableView) -> Int {
        var cellNum = 0
        for section in 0..<tableView.numberOfSections {
            let rowNum = tableView.numberOfRows(inSection: section)
            cellNum += rowNum
        }
        return cellNum
    }

    func cellNumInCollectionView(collectionView: UICollectionView) -> Int {
        var cellNum = 0
        for section in 0..<collectionView.numberOfSections {
            let rowNum = collectionView.numberOfItems(inSection: section)
            cellNum += rowNum
        }
        return cellNum
    }

    override func observeValue(
        forKeyPath keyPath: String?, of object: Any?,
        change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?
    ) {
        if keyPath == "contentOffset" {
            DispatchQueue.main.async {
                if (self.superView?.isKind(of: UITableView.classForCoder()))! {
                    if let tableView = self.superView as? UITableView {
                        let lastSection = tableView.numberOfSections - 1
                        if lastSection >= 0 {
                            let lastRow =
                                tableView.numberOfRows(
                                    inSection: tableView.numberOfSections - 1)
                                - 1
                            if lastRow >= 0 {
                                if tableView.visibleCells.count > 0 {
                                    if let indexPath = tableView.indexPath(
                                        for: tableView.visibleCells.last!)
                                    {
                                        if indexPath.section == lastSection
                                            && indexPath.row >= lastRow
                                                - self.surplusCount
                                        {
                                            if self.loadingType
                                                == .LoadStateIdle
                                                || self.loadingType
                                                    == .LoadStateFailed
                                            {
                                                self.startLoading()
                                                self.onLoad?()
                                            }
                                        }
                                        if indexPath.section == lastSection
                                            && indexPath.row == lastRow
                                        {
                                            self.frame = CGRect.init(
                                                x: 0,
                                                y: tableView.visibleCells.last?
                                                    .frame.maxY ?? 0,
                                                width: screenWidth, height: 50)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if (self.superView?.isKind(of: UICollectionView.classForCoder()))!
                {
                    if let collectionView = self.superView as? UICollectionView
                    {
                        let lastSection = collectionView.numberOfSections - 1
                        if lastSection >= 0 {
                            let lastRow =
                                collectionView.numberOfItems(
                                    inSection: collectionView.numberOfSections
                                        - 1) - 1
                            if lastRow >= 0 {
                                if collectionView.visibleCells.count > 0 {
                                    let indexPaths = collectionView
                                        .indexPathsForVisibleItems
                                    let orderedIndexPaths = indexPaths.sorted(
                                        by: { $0.row < $1.row })
                                    if let indexPath = orderedIndexPaths.last {
                                        if indexPath.section == lastSection
                                            && indexPath.row >= lastRow
                                                - self.surplusCount
                                        {
                                            if self.loadingType
                                                == .LoadStateIdle
                                                || self.loadingType
                                                    == .LoadStateFailed
                                            {
                                                self.startLoading()
                                                self.onLoad?()
                                            }
                                        }
                                        if indexPath.section == lastSection
                                            && indexPath.row == lastRow
                                        {
                                            if let cell =
                                                collectionView.cellForItem(
                                                    at: indexPath)
                                            {
                                                self.frame = CGRect.init(
                                                    x: 0, y: cell.frame.maxY,
                                                    width: screenWidth,
                                                    height: 50)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            super.observeValue(
                forKeyPath: keyPath, of: object, change: change,
                context: context)
        }
    }

    func reset() {
        loadingType = .LoadStateIdle
        self.frame = originalFrame
    }

    func startLoading() {
        if loadingType != .LoadStateLoading {
            loadingType = .LoadStateLoading
        }
    }

    func endLoading() {
        if loadingType != .LoadStateIdle {
            loadingType = .LoadStateIdle
        }
    }

    func loadingFailed() {
        if loadingType != .LoadStateFailed {
            loadingType = .LoadStateFailed
        }
    }
    func loadingAll() {
        if loadingType != .LoadStateAll {
            loadingType = .LoadStateAll
        }
    }

    func updateFrame() {
        if (superView?.isKind(of: UITableView.classForCoder()))! {
            if let tableView = superView as? UITableView {
                let y: CGFloat =
                    tableView.contentSize.height > originalFrame.origin.y
                    ? tableView.contentSize.height : originalFrame.origin.y
                self.frame = CGRect.init(
                    x: 0, y: y, width: screenWidth, height: 50)
            }
        }
        if (superView?.isKind(of: UICollectionView.classForCoder()))! {
            if let collectionView = superView as? UICollectionView {
                let y: CGFloat =
                    collectionView.contentSize.height > originalFrame.origin.y
                    ? collectionView.contentSize.height : originalFrame.origin.y
                self.frame = CGRect.init(
                    x: 0, y: y, width: screenWidth, height: 50)
            }
        }
    }

    func startAnim() {
        let rotationAnimation = CABasicAnimation.init(
            keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber.init(value: .pi * 2.0)
        rotationAnimation.duration = 1.5
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = MAXFLOAT
        indicator.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }

    func stopAnim() {
        indicator.layer.removeAllAnimations()
    }

    deinit {
        superView?.removeObserver(self, forKeyPath: "contentOffset")
    }
}


/*代码主要功能：
 
 这段代码实现了一个自定义的 LoadMoreControl 控件，通常用于列表控件（如 UITableView 或 UICollectionView）的底部，当用户滚动到列表底部时，触发加载更多的操作。

 核心功能与实现：

 加载状态管理：
 定义了四种加载状态：LoadStateIdle（空闲）、LoadStateLoading（加载中）、LoadStateAll（全部加载完）、LoadStateFailed（加载失败）。
 根据不同的状态显示不同的 UI 和执行不同的操作。
 滚动监听：
 通过 KVO 监听 UIScrollView 的 contentOffset 属性，实时监测滚动位置。
 当用户滚动到列表底部时，判断是否满足加载条件，触发加载操作。
 加载触发：
 当满足加载条件时，调用 onLoad 回调函数，由外部代码实现具体的加载逻辑。
 UI 更新：
 根据加载状态更新控件的 UI，包括显示加载指示器、提示文字等。
 动画效果：
 使用 CABasicAnimation 实现加载指示器的旋转动画。
 代码结构与关键点：

 属性：
 surplusCount：触发加载的阈值，即距离列表底部还有多少个 cell 时开始加载。
 loadingType：当前的加载状态。
 onLoad：加载回调函数。
 indicator：加载指示器。
 label：提示文字标签。
 方法：
 initSubView：初始化子视图。
 observeValueForKeyPath：监听滚动事件。
 startLoading、endLoading、loadingFailed、loadingAll：更新加载状态。
 startAnim、stopAnim：控制动画。
 updateFrame：更新控件的位置。
 cellNumInTableView、cellNumInCollectionView：计算列表中的 cell 数量。
 使用方式：

 创建实例： 在列表控件中创建一个 LoadMoreControl 实例，设置 surplusCount 和 onLoad 属性。
 添加到列表控件： 将 LoadMoreControl 实例添加到列表控件的底部。
 实现 onLoad 回调： 在 onLoad 回调函数中实现具体的加载数据逻辑。
 总结：

 这段代码提供了一个灵活且可复用的加载更多控件，可以方便地集成到各种列表控件中。通过自定义 surplusCount 和 onLoad，可以适应不同的业务需求。

 可能存在的问题与改进：

 代码复杂度： 由于需要处理多种状态和情况，代码逻辑相对复杂。
 可扩展性： 如果需要支持更多的自定义配置，代码可能会变得更加复杂。
 性能优化： 在高性能要求的场景下，可以考虑优化动画效果和布局计算。
 改进建议：

 简化代码： 可以通过提取公共方法、使用枚举等方式来简化代码。
 增加注释： 可以为关键代码添加注释，提高代码的可读性。
 使用约束布局： 可以使用 SnapKit 等约束布局库，简化布局代码。
 引入 MVVM 模式： 可以将视图、视图模型和数据模型分离，提高代码的可维护性。*/
