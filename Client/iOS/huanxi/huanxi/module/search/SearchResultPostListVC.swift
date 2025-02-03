//
//  SearchResultPostListVC.swift
//  huanxi
//
//  Created by rslz on 2024/12/23.
//

import UIKit
import SnapKit
import JXSegmentedView

class SearchResultPostListVC: BaseViewController {
    
    var keyword: String = ""
    
    private var searchPostList:[SearchViewModel.CellType] = []


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
    
    private let viewModel = SearchResultViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        sh_prefersNavigationBarHidden = true
        setupUI()
        bindUI()
        self.loadData(keyword: keyword)
    }
    
    func setupUI() {
        view.addSubview(collectionView)
    }
    
    func bindUI() {
        self.viewModel.searchPosts
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
                    self.searchPostList = cellTypes
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
            self.loadData(keyword: self.keyword)
        }
    }

}

extension SearchResultPostListVC {
    private func loadData(keyword: String) {
        viewModel.requestSearchPost(keyword: keyword, completion: {success in })
    }
}

extension SearchResultPostListVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchPostList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = searchPostList.ck_objIndex(indexPath.item) else {
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
        guard let item = searchPostList.ck_objIndex(indexPath.item) else { return }
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

extension SearchResultPostListVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

/*代码主要功能：
 
 这段 Swift 代码实现了一个搜索结果的帖子列表页面。当用户输入关键词进行搜索后，这个页面会展示搜索到的帖子列表，并支持点击帖子跳转到详情页。

 代码结构和主要部分：

 SearchResultPostListVC 类：
 属性：
 keyword：存储用户输入的搜索关键词。
 searchPostList：用于存储搜索结果的帖子列表，每个元素是一个枚举类型 SearchViewModel.CellType，表示不同的 cell 类型（如骨架屏、帖子等）。
 collectionView：用来展示帖子列表的 UICollectionView。
 emptyView：当没有搜索结果或发生错误时显示的空视图。
 viewModel：负责数据请求和管理的视图模型。
 方法：
 viewDidLoad：初始化界面，绑定数据，发起网络请求。
 setupUi：设置 collectionView 的约束。
 bindUI：将 viewModel 中的搜索结果数据绑定到 collectionView 上，并处理空状态和错误状态。
 setEmptyOrNetErrorView：设置空视图或错误视图。
 loadData：发起网络请求获取搜索结果。
 数据绑定：
 使用 RxSwift 进行数据绑定，将 viewModel 中的搜索结果数据实时更新到 collectionView 上。
 当搜索结果为空或发生错误时，显示对应的空视图。
 用户交互：
 点击 collectionView 中的帖子项，会跳转到对应的帖子详情页。
 代码流程：

 初始化： 在 viewDidLoad 方法中，设置界面，绑定数据，发起网络请求获取搜索结果。
 数据展示： 将获取到的搜索结果数据绑定到 collectionView 上，并在 collectionView 中展示。
 空状态处理： 根据搜索结果，显示对应的空视图（无结果或网络错误）。
 用户交互： 用户点击 collectionView 中的某一项时，跳转到对应的帖子详情页。
 代码亮点：

 使用 RxSwift 进行数据绑定： 使代码更简洁，提高了数据流的可读性。
 采用 MVVM 设计模式： 将视图和数据逻辑分离，提高代码的可维护性。
 处理空状态和错误状态： 给用户友好的提示。
 用户交互： 实现点击帖子跳转到详情页的功能。
 可能存在的问题和改进点：

 错误处理： 可以添加更多的错误处理，比如网络请求失败时的处理。
 性能优化： 如果数据量较大，可以考虑使用分页加载，提高性能。
 UI/UX： 可以根据设计稿对界面进行优化，提高用户体验。
 测试： 可以编写单元测试，保证代码的正确性。
 总结：

 这段代码实现了一个功能完善的帖子搜索列表页面，使用了较好的设计模式和框架。通过对代码的分析，我们可以更深入地了解其内部实现细节，并为后续的代码优化提供参考。
 */
