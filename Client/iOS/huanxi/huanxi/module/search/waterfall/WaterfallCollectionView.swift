//
//  WaterfallCollectionView.swift
//  huanxi
//
//  Created by jack on 2024/6/22.
//

import UIKit

class WaterfallCollectionView: BaseView {
    var didSelectItemBlock: ((IndexPath) -> Void)?

    private lazy var layout: WaterfallFlowLayout = {
        let layout = WaterfallFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.delegate = self
        return layout
    }()

    // 创建 UICollectionView 实例，并且引用 layout 对象
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(WaterfallCollectionViewCell.self, forCellWithReuseIdentifier: WaterfallCollectionViewCell.reuseIdentifier)
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black

        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var items: [PostModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
}

extension WaterfallCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaterfallCollectionViewCell.reuseIdentifier, for: indexPath) as? WaterfallCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.model = items?[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let block = didSelectItemBlock {
            block(indexPath)
        }
    }
}

extension WaterfallCollectionView: WaterfallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let model = items?[indexPath.item]
        return model?.imageHeight ?? 0
    }
}
