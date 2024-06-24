//
//  WaterfallCollectionView.swift
//  huanxi
//
//  Created by jack on 2024/6/22.
//

import UIKit

class WaterfallCollectionView: UICollectionView, UICollectionViewDataSource, WaterfallLayoutDelegate {
    private var items: [String] = []
    private var itemHeights: [CGFloat] = []
    
    init(frame: CGRect, numberOfColumns: Int) {
        let layout = WaterfallFlowLayout(numberOfColumns: numberOfColumns)
        super.init(frame: frame, collectionViewLayout: layout)
        self.dataSource = self
        layout.delegate = self
        self.register(WaterfallCollectionViewCell.self, forCellWithReuseIdentifier: WaterfallCollectionViewCell.reuseIdentifier)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItems(_ items: [String], heights: [CGFloat]) {
        self.items = items
        self.itemHeights = heights
        self.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaterfallCollectionViewCell.reuseIdentifier, for: indexPath) as? WaterfallCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: items[indexPath.item])
        return cell
    }
    
    // 实现 WaterfallLayoutDelegate 协议方法
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        return itemHeights[indexPath.item]
    }
}
