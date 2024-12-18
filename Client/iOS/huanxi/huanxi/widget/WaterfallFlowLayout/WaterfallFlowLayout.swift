//
//  WaterfallFlowLayout.swift
//  huanxi
//
//  Created by jack on 2024/3/2.
//

import UIKit

protocol WaterfallLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
}

class WaterfallFlowLayout: UICollectionViewFlowLayout {
    private var numberOfColumns: Int = 3
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var heightCache: [IndexPath: CGFloat] = [:] // 缓存高度

    weak var delegate: WaterfallLayoutDelegate?

    override init() {
        super.init()
        minimumInteritemSpacing = 5
        minimumLineSpacing = 5
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        // 计算列宽，考虑列间距
        let columnWidth = (collectionView.bounds.width - CGFloat(numberOfColumns - 1) * minimumInteritemSpacing) / CGFloat(numberOfColumns)
        
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * (columnWidth + minimumInteritemSpacing))
        }
        
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        var column = 0
        cache.removeAll()
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // 如果缓存中没有高度，从 delegate 获取并缓存
            if heightCache[indexPath] == nil {
                let itemHeight = delegate?.collectionView(collectionView, heightForItemAt: indexPath) ?? 0
                heightCache[indexPath] = itemHeight
            }
            
            let itemHeight = heightCache[indexPath] ?? 0
            let height = itemHeight  // 每个item的高度，不加行间距
            
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            
            // 更新yOffset时加上行间距
            yOffset[column] = yOffset[column] + height + minimumLineSpacing
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.bounds.width ?? 0, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }

    // 手动刷新布局
    func invalidateLayoutOnDataChange() {
        let context = UICollectionViewFlowLayoutInvalidationContext()
        context.invalidateItems(at: [IndexPath(item: 0, section: 0)]) // 可以根据需要选择刷新的部分
        invalidateLayout(with: context)
    }
}
