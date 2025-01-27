//
//  MineCollectListVC.swift
//  huanxi
//
//  Created by rslz on 2025/1/20.
//

import UIKit
import SnapKit
import JXSegmentedView
import Combine

class MineCollectListVC: BaseViewController {
    
    var listType: MineViewModel.ListType = .publish
    
    var userId: String = ""

    private var dataList:[MineViewModel.CellType] = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.scrollDirection = .vertical
        let cellWidth = (.screenWidth - 4) / 3
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        let collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 10, width: .screenWidth, height: .screenHeight - UIDevice.sy_navigationFullHeight - 60), collectionViewLayout: layout)
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
    
    private let viewModel = MineViewModel()

    private var cancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        sh_prefersNavigationBarHidden = true
        setupUI()
        bindUI()
        self.loadData()
        
        cancellable = NotificationCenter.default.publisher(for: listType == .publish ? .refreshMainPageNotification : .collectNotification)
            .sink { notification in
                if(LoginManager.shared.isLogin()) {
                    self.loadData()
                } else {
                    self.dataList = []
                    self.collectionView.reloadData()
                }
            }
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func setupUI() {
        view.addSubview(collectionView)
    }
    
    func bindUI() {
        self.viewModel.dataList
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
                    self.dataList = cellTypes
                    self.collectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
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

extension MineCollectListVC {
    private func loadData() {
        viewModel.requestPostList(type: listType, userId: userId) { success in
        }
    }
}

extension MineCollectListVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = dataList.ck_objIndex(indexPath.item) else {
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
        guard let item = dataList.ck_objIndex(indexPath.item) else { return }
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

extension MineCollectListVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}


/*代码功能：
 
 这段代码定义了一个名为 MineCollectListVC 的视图控制器，用于展示用户收藏的帖子列表。它主要负责：

 数据获取: 从 MineViewModel 获取用户收藏的帖子数据。
 UI展示: 使用 UICollectionView 以网格布局展示帖子列表。
 空状态处理: 当没有收藏的帖子时，显示空状态视图。
 错误处理: 当网络请求失败时，显示错误提示。
 交互: 处理用户点击帖子时的跳转。
 代码结构:

 属性:
 listType: 表示当前列表是发布的帖子还是收藏的帖子。
 userId: 表示当前用户 ID。
 dataList: 存储从 MineViewModel 获取的帖子数据。
 collectionView: 用于展示帖子的集合视图。
 emptyView: 用于显示空状态或错误状态的视图。
 viewModel: MineViewModel 的实例，用于获取数据。
 方法:
 viewDidLoad：初始化视图，设置 UI，绑定数据，加载数据。
 setupUI：设置 UI 布局。
 bindUI：将 viewModel 的数据绑定到 collectionView 上，实现数据更新。
 loadData：从 viewModel 获取帖子数据。
 setEmptyOrNetErrorView：显示空状态或错误视图。
 collectionView 的代理方法：处理单元格的创建、复用、点击事件等。
 代码逻辑:

 初始化: 在 viewDidLoad 中，设置 UI，绑定数据，并加载初始数据。
 数据绑定: 通过 bindUI 方法将 viewModel 的 dataList 绑定到 collectionView 的数据源，当 dataList 发生变化时，collectionView 会自动刷新。
 数据加载: loadData 方法调用 viewModel.requestPostList 获取帖子数据，并更新 dataList。
 UI展示: collectionView 显示帖子列表，每个帖子对应一个 SearchTagListCell。
 空状态和错误处理: 当没有数据或发生错误时，显示 emptyView。
 用户交互: 点击帖子时，跳转到帖子详情页。
 代码亮点:

 模块化: 将数据获取、UI展示、用户交互等功能模块化。
 数据绑定: 使用 RxSwift 或 Combine 等响应式编程框架，实现数据与 UI 的自动同步。
 空状态和错误处理: 提供了友好的用户提示。
 可扩展性: 可以通过自定义 CellType 来支持更多的 cell 类型。
 潜在改进:

 分页加载: 对于大量数据，可以实现分页加载，提高性能。
 下拉刷新: 添加下拉刷新功能，让用户可以手动刷新数据。
 错误处理: 可以更细粒度地处理错误，例如显示不同的错误信息。
 性能优化: 可以优化图片加载、布局计算等，提高性能。

*/

