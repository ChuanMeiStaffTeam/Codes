//
//  SearchViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit

class SearchViewController: BaseViewController {
    private let searchHeaderView = SearchHeaderView()
    private let searchTagsView = SearchTagsView()
    private let nav = NavigationController(rootViewController: SearchSugViewController())

    private lazy var emptyView: CCEmptyView = {
        let emptyView = CCEmptyView()
        return emptyView
    }()
    
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
    
    private let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        sh_prefersNavigationBarHidden = true
        setupUI()
        bindUI()
        refrehData()
    }

    func setupUI() {
        searchHeaderView.didClickViewCallBack = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.nav.modalPresentationStyle = .overFullScreen
                self.present(self.nav, animated: false)
            }
        }
        view.addSubview(searchHeaderView)
        searchHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.sy_navigationFullHeight)
        }
        
        searchTagsView.didSelectedItemCallBack = { [weak self] text in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                let vc = SearchTagViewController()
                vc.title = text
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }
        view.addSubview(searchTagsView)
        searchTagsView.snp.makeConstraints { make in
            make.top.equalTo(searchHeaderView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTagsView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(UIDevice.sy_tabBarFullHeight)
        }
    }
    
    func bindUI() {
        self.viewModel.postsList
            .subscribe(onNext: { [weak self] cellTypes in
                guard let `self` = self else { return }
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        self.viewModel.postTagList
            .subscribe(onNext: { [weak self] tags in
                guard let `self` = self else { return }
                self.searchTagsView.reloadData(tags)
            })
            .disposed(by: disposeBag)
    }

}

extension SearchViewController {
    private func refrehData() {
        viewModel.requestDefaultSearchPosts {result in
        }
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.postsList.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = self.viewModel.postsList.value.ck_objIndex(indexPath.item) else {
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
        guard let item = self.viewModel.postsList.value.ck_objIndex(indexPath.item) else { return }
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
 
 这段代码定义了一个名为 WaterfallCollectionView 的自定义视图，主要用于实现瀑布流布局的图片展示。它可以根据数据源动态地调整每个图片单元格的高度，并支持多种交互功能，比如点击查看详情等。

 核心功能

 瀑布流布局: 使用 WaterfallFlowLayout 实现瀑布流布局，可以根据图片的实际高度动态调整每个 cell 的高度。
 数据展示: 通过 items 属性绑定数据源，根据数据源中的不同类型（图片、骨架屏、空状态等）渲染不同的 cell。
 点击事件: 支持点击事件，当用户点击图片 cell 时，通过 didSelectItemBlock 回调通知外部。
 骨架屏: 在数据加载过程中显示占位符，提升用户体验。
 代码结构

 WaterfallCollectionView 类:

 属性:
 didSelectItemBlock: 点击图片时的回调。
 layout: 瀑布流布局对象。
 collectionView: UICollectionView 实例。
 items: 存储数据源的数组。
 方法:
 init(frame:): 初始化视图，设置布局和子视图。
 collectionView(_:numberOfItemsInSection:): 返回数据源的个数。
 collectionView(_:cellForItemAt:): 根据数据源类型创建并返回对应的 cell。
 collectionView(_:didSelectItemAt:): 处理图片点击事件。
 collectionView(_:heightForItemAt:): 根据数据源计算每个 cell 的高度。
 WaterfallCollectionViewCell 类:

 负责显示单个图片的 cell，包括图片展示和骨架屏动画。
 在之前的分析中已经详细介绍。
 关键概念

 瀑布流布局: 是一种不规则的网格布局，每个 cell 的高度不固定，可以根据内容动态调整。
 数据源: items 数组存储了要展示的数据，包括图片数据、骨架屏数据、空状态数据等。
 骨架屏: 在数据加载过程中显示占位符，提升用户体验。
 委托协议: WaterfallLayoutDelegate 协议用于计算每个 cell 的高度。
 总结

 WaterfallCollectionView 是一个功能较为完善的自定义视图，适用于瀑布流布局的图片展示场景。它结合了瀑布流布局、数据绑定、骨架屏动画等技术，提供了良好的用户体验。

*/
