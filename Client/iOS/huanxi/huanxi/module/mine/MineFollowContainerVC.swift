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
