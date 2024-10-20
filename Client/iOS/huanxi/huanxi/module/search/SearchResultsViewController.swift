//
//  SearchResultsViewController.swift
//  huanxi
//
//  Created by jack on 2024/6/23.
//

import UIKit
import SnapKit

class SearchResultsViewController: BaseViewController {
    private var items: [String] = ["热门搜索", "账户", "标签", "地点"] // 假设有4个Item
    private var selectedIndex: IndexPath = IndexPath(item: 0, section: 0)
    
    let searchHeaderView = SearchResultHeaderView(frame: CGRect.init(x: 0, y: 0, width: .screenWidth, height: .topBarHeight))

    private lazy var topCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(TopItemCell.self, forCellWithReuseIdentifier: TopItemCell.identifier)
        return collectionView
    }()
    
    private lazy var bottomCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(BottomContentCell.self, forCellWithReuseIdentifier: BottomContentCell.identifier)
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        
        searchHeaderView.backCallBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(searchHeaderView)

        view.addSubview(topCollectionView)
        view.addSubview(bottomCollectionView)
        
        topCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.topBarHeight)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        bottomCollectionView.snp.makeConstraints { make in
            make.top.equalTo(topCollectionView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SearchResultsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopItemCell.identifier, for: indexPath) as? TopItemCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: items[indexPath.item], isSelected: indexPath == selectedIndex)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomContentCell.identifier, for: indexPath) as? BottomContentCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: items[indexPath.item]) // 可以传递数据给内容视图
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topCollectionView {
            return CGSize(width: 100, height: 50) // 顶部Item的尺寸
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topCollectionView {
            selectedIndex = indexPath
            topCollectionView.reloadData()
            bottomCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == bottomCollectionView {
            let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
            selectedIndex = IndexPath(item: index, section: 0)
            topCollectionView.reloadData()
            topCollectionView.scrollToItem(at: selectedIndex, at: .centeredHorizontally, animated: true)
        }
    }
}
