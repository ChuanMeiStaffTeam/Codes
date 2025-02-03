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

/*代码主要功能：
 
 这段 Swift 代码实现了一个搜索结果的容器视图控制器，用于展示不同类型的搜索结果（如帖子、用户等）。它提供了一个分段控件，让用户可以在帖子搜索结果和用户搜索结果之间切换。

 代码结构和主要部分：

 SearchResultContainerVC 类：
 属性：
 keyword：存储用户输入的搜索关键词。
 headerView：搜索结果页面的头部视图，包含返回按钮和搜索框。
 titleDataSource：为分段控件提供标题和样式的数据源。
 segmentedView：用于在帖子搜索结果和用户搜索结果之间切换的分段控件。
 listContainerView：用于管理不同分段对应的视图控制器。
 方法：
 viewDidLoad：初始化界面，绑定数据。
 viewWillAppear 和 viewWillDisappear：控制导航栏返回手势的启用和禁用。
 setupUi：设置 UI 界面布局。
 bindUI：绑定点击事件，如返回按钮点击事件和搜索框点击事件。
 数据绑定和交互：
 使用 JXSegmentedView 和 JXSegmentedListContainerView 实现分段控件和视图容器的管理。
 点击不同的分段，会加载对应的搜索结果视图控制器。
 点击返回按钮，会返回上一级页面。
 代码流程：

 初始化： 在 viewDidLoad 方法中，设置 UI 界面，绑定数据。
 分段切换： 用户点击不同的分段时，会加载对应的搜索结果视图控制器，并更新 UI。
 返回： 点击返回按钮时，返回上一级页面。
 代码亮点：

 使用 JXSegmentedView： 实现了一个美观且功能强大的分段控件。
 数据绑定： 使用 RxSwift 进行数据绑定，提高代码可读性。
 导航控制： 灵活控制导航栏返回手势的启用与禁用。
 模块化设计： 将不同的功能模块化，提高代码可维护性。
 可能存在的问题和改进点：

 数据源的更新： 当用户再次搜索时，需要更新各个分段对应的搜索结果。
 性能优化： 如果搜索结果很多，可以考虑分页加载，提高性能。
 UI/UX： 可以根据设计稿对界面进行优化，提高用户体验。
 测试： 可以编写单元测试，保证代码的正确性。
 总结：

 这段代码实现了一个功能完善的搜索结果容器视图控制器，可以根据用户选择的类型展示不同的搜索结果。代码结构清晰，可读性高，使用了较好的设计模式和框架。

*/
