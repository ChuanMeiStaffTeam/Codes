//
//  SearchResultContainerVC.swift
//  huanxi
//
//  Created by rslz on 2024/12/23.
//

import UIKit
import SnapKit
import JXSegmentedView

class SearchResultContainerVC: BaseViewController {
    
    var keyword: String = ""
    
    private let headerView = SearchResultHeaderView()

    private let titleDataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isItemSpacingAverageEnabled = false
        dataSource.titles = [SearchResultType.hotPost.value, SearchResultType.account.value]
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
        sh_prefersNavigationBarHidden = true
        setupUI()
        bindUI()
    }
    
    func setupUI() {
        headerView.textField.placeholder = keyword
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.sy_navigationFullHeight)
        }
        
        segmentedView.dataSource = titleDataSource
        segmentedView.delegate = self
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
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
        headerView.backButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        headerView.textField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.headerView.textField.resignFirstResponder()
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension SearchResultContainerVC: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = titleDataSource as? JXSegmentedDotDataSource {
            //先更新数据源的数据
            dotDataSource.dotStates[index] = false
            //再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
        }

        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
}

extension SearchResultContainerVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        switch index {
        case SearchResultType.hotPost.rawValue:
            let vc = SearchResultPostListVC()
            vc.keyword = self.keyword
            return vc
        case SearchResultType.account.rawValue:
            let vc = SearchResultUserListVC()
            vc.keyword = self.keyword
            return vc
        default:
            let vc = SearchResultPostListVC()
            vc.keyword = self.keyword
            return vc
        }
    }
}
