//
//  SearchTagViewController.swift
//  huanxi
//
//  Created by jack on 2024/6/22.
//

import UIKit

class SearchTagViewController: BaseViewController {
    
    private let viewModel = SearchViewModel()
    
    private var tagPostsList:[SearchViewModel.CellType] = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.scrollDirection = .vertical
        let cellWidth = (.screenWidth - 4) / 3
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        let collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: .screenWidth, height: .screenHeight), collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SearchTagListCell.self, forCellWithReuseIdentifier: SearchTagListCell.defaultReuseIdentifier)
        collectionView.register(SpaceCollectionViewCell.self, forCellWithReuseIdentifier: SpaceCollectionViewCell.defaultReuseIdentifier)

        return collectionView
    }()
    
    private lazy var emptyView: CCEmptyView = {
        let emptyView = CCEmptyView()
        return emptyView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindUI()
        loadData()
    }
    
    
    func setupView() {
        view.addSubview(collectionView)
    }
    
    func bindUI() {
        self.viewModel.tagPostsList
            .subscribe(onNext: { [weak self] cellTypes in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    if cellTypes.isEmpty {
                        self.setEmptyOrNetErrorView(.noData)
                    } else if cellTypes.first == .error {
                        self.setEmptyOrNetErrorView(.noNetwork)
                    } else {
                        self.emptyView.removeFromSuperview()
                    }
                    self.tagPostsList = cellTypes
                    self.collectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }

    
    func loadData()  {
        viewModel.requestTagPosts(tags: self.title ?? "") { result in
        }
    }
    
    // MARK: - 设置空视图or错误视图
    private func setEmptyOrNetErrorView(_ type: CCEmptyType) {
        emptyView.removeFromSuperview()
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-80)
            make.centerX.equalToSuperview()
        }
        emptyView.updateType(type: type)
        emptyView.reloadBlock = { [weak self] in
            guard let self = self else { return }
            self.loadData()
        }
    }
}

extension SearchTagViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagPostsList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = tagPostsList.ck_objIndex(indexPath.item) else {
            return collectionView.dequeueReusableCell(forIndexPath: indexPath) as SpaceCollectionViewCell
        }
        switch item {
        case .skeleton:
            let cell: SearchTagListCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.isSkeletonVisible = true
            return cell
        case .postItem(let post):
            let cell: SearchTagListCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.isSkeletonVisible = false
            if let urlStr = post.images?.first?.imageUrl {
                cell.imgView.kf.setImage(with: URL.init(string: urlStr))
            }
            return cell
        default:
            return collectionView.dequeueReusableCell(forIndexPath: indexPath) as SpaceCollectionViewCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = tagPostsList.ck_objIndex(indexPath.item) else { return }
        switch item {
        case .postItem(let post):
            let vc = PostDetailViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.postItem = post
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
}

/*代码功能

这段代码定义了一个名为 SearchTagViewController 的视图控制器，用于展示特定标签下的帖子列表。

核心功能

数据获取: 从 SearchViewModel 获取指定标签下的帖子列表数据。
数据展示: 使用 UICollectionView 以瀑布流布局展示帖子列表。
骨架屏: 在数据加载过程中显示骨架屏，提升用户体验。
空状态处理: 当没有数据或网络错误时，显示相应的空状态视图。
帖子点击: 支持点击帖子跳转到帖子详情页面。
代码结构

SearchTagViewController 类:
属性:
viewModel: 搜索视图模型，负责数据请求和管理。
tagPostsList: 存储帖子列表数据的数组。
collectionView: 用于展示帖子的 UICollectionView。
emptyView: 空状态视图。
方法:
viewDidLoad：初始化视图，绑定数据，加载数据。
setupView：设置界面布局。
bindUI：绑定视图模型和 UI 组件，实现数据双向绑定。
loadData：从 SearchViewModel 请求指定标签下的帖子数据。
setEmptyOrNetErrorView：设置空状态视图或网络错误视图。
SearchTagListCell 类:
自定义的 UICollectionViewCell，用于展示单个帖子。
包括图片展示、骨架屏动画等功能。
代码流程

初始化:
viewDidLoad 中初始化视图，绑定 UI 组件，并调用 loadData 方法获取数据。
数据请求:
loadData 方法调用 SearchViewModel 的 requestTagPosts 方法，向服务器请求指定标签下的帖子数据。
数据接收:
bindUI 中订阅 viewModel.tagPostsList 的变化，当接收到新的数据时，更新 tagPostsList 数组，并刷新 collectionView。
数据展示:
collectionView(_:numberOfItemsInSection:) 返回数据源的个数。
collectionView(_:cellForItemAt:) 根据数据类型创建并返回对应的 cell。
点击事件:
点击帖子 cell 时，跳转到帖子详情页面。
空状态处理:
当数据为空或网络错误时，显示相应的空状态视图。
关键概念

数据绑定: 使用 RxSwift 绑定 viewModel 和 UI 组件，实现数据变化时 UI 的自动更新。
骨架屏: 在数据加载过程中显示占位符，提升用户体验。
空状态处理: 当没有数据或网络错误时，显示相应的提示信息。
瀑布流布局: 使用 UICollectionViewFlowLayout 实现瀑布流布局，优化界面展示。
可能存在的优化点

分页加载: 对于大量数据，可以采用分页加载的方式，提高性能。
缓存机制: 可以缓存数据，减少重复请求。
错误处理: 可以添加更细粒度的错误处理，例如显示具体的错误信息。
用户体验: 可以添加下拉刷新、上拉加载更多等交互功能。
总结

SearchTagViewController 是一个功能较为完善的视图控制器，用于展示特定标签下的帖子列表。它结合了数据绑定、骨架屏、空状态处理等技术，提供了良好的用户体验。
 */
