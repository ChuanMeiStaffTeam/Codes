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
        let vc = SearchDetailListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

