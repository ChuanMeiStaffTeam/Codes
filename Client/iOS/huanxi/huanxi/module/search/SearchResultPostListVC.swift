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
        let vc = SearchDetailListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchResultPostListVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
