//
//  MineFollowContainerVC.swift
//  huanxi
//
//  Created by rslz on 2025/1/20.
//

import UIKit
import SnapKit
import JXSegmentedView

enum FollowListType: Int {
    /// 0-关注
    case follow = 0
    /// 1- 粉丝
    case fans = 1

    var value: String {
        switch self {
        case .follow:
            return "关注"
        case .fans:
            return "粉丝"
        }
    }
}

class MineFollowContainerVC: BaseViewController {
    
    var currentUser: UserInfoModel?
    
    var listType: FollowListType = .follow

    private let titleDataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isItemSpacingAverageEnabled = true
        dataSource.titles = [FollowListType.follow.value, FollowListType.fans.value]
        dataSource.titleNormalColor = UIColor.white_60
        dataSource.titleSelectedColor = .white
        dataSource.itemSpacing = 30
        return dataSource
    }()
        
    private let segmentedView: JXSegmentedView = {
        let view = JXSegmentedView()
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor = .white
        indicator.indicatorWidthIncrement = 10
        indicator.indicatorHeight = 2
        view.indicators = [indicator]
        return view
    }()
    
    lazy var listContainerView: JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //处于第一个item的时候，才允许屏幕边缘手势返回
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentUser?.fullName == nil ? currentUser?.username : currentUser?.fullName
        setupUI()
        bindUI()
    }
    
    func setupUI() {
        segmentedView.dataSource = titleDataSource
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(UIDevice.sy_navigationFullHeight)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }

        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    func bindUI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.segmentedView.selectItemAt(index: self.listType.rawValue)
        }
    }

}

extension MineFollowContainerVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let vc = MineFollowListVC()
        vc.listType = FollowListType(rawValue: index) ?? .follow
        vc.userId = self.currentUser?.userId ?? 0
        return vc
    }
}

/*这段代码主要实现了一个用户关注列表和粉丝列表的切换功能。
 
 代码功能拆解：

 FollowListType 枚举: 定义了两种列表类型：关注和粉丝。
 MineFollowContainerVC 类:
 负责管理关注和粉丝列表的切换。
 使用 JXSegmentedView 实现顶部分段控件。
 使用 JXSegmentedListContainerView 管理不同列表对应的子控制器。
 通过 MineFollowListVC 子控制器来展示具体的关注或粉丝列表。
 segmentedView: 分段控件，用于在关注和粉丝列表之间切换。
 listContainerView: 容器视图，用于承载不同的列表视图控制器。
 MineFollowListVC: 子控制器，负责展示具体的关注或粉丝列表。
 代码逻辑:

 创建 MineFollowContainerVC 实例: 初始化时设置当前用户和初始列表类型。
 设置 UI: 创建分段控件、容器视图，并设置约束。
 绑定数据: 将分段控件的数据源设置为 titleDataSource，将容器视图的数据源设置为 self。
 切换列表: 用户点击分段控件时，会触发 JXSegmentedListContainerView 的代理方法，从而切换到对应的列表视图控制器。
 子控制器: MineFollowListVC 负责展示具体的关注或粉丝列表，它会根据 listType 从服务器获取数据并展示。
 代码亮点:

 使用 JXSegmentedView: 简化了分段控件的实现。
 使用 JXSegmentedListContainerView: 方便管理多个列表视图控制器。
 代码结构清晰: 代码结构清晰，职责分明。
 支持自定义: 可以通过自定义 JXSegmentedView 的样式来实现不同的 UI 效果。
 潜在改进:

 数据缓存: 可以缓存用户关注和粉丝列表的数据，减少网络请求。
 下拉刷新: 可以添加下拉刷新功能，实现列表数据的实时更新。
 分页加载: 对于大量数据，可以采用分页加载的方式，提高性能。
 错误处理: 可以添加错误处理机制，例如网络请求失败时的提示。*/
