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


/*代码功能:

实现瀑布流布局: 该代码定义了一个名为 WaterfallFlowLayout 的自定义 UICollectionViewFlowLayout 子类，用于实现瀑布流布局效果。
动态计算高度: 委托协议 WaterfallLayoutDelegate 允许外部代码动态计算每个 cell 的高度，从而实现高度不固定的瀑布流。
高度缓存: 使用 heightCache 缓存已经计算过的 cell 高度，提高布局性能。
代码原理:

计算列宽: 根据 numberOfColumns 和 minimumInteritemSpacing 计算出每列的宽度。
初始化: 创建一个数组 yOffset，用于记录每列的当前高度。
遍历数据: 循环遍历每个 cell，计算其高度并将其添加到当前高度最小的列。
更新布局: 更新每个 cell 的 frame，并计算整个 collectionView 的内容高度。
缓存布局属性: 将计算好的布局属性缓存到 cache 数组中，提高后续布局的性能。
关键方法:

prepare(): 准备布局，计算列宽、初始化 yOffset 数组等。
heightForRowAtIndexPath(_:collectionView:indexPath:): 委托方法，用于获取每个 cell 的高度。
layoutAttributesForElements(in:): 返回指定区域内的布局属性。
layoutAttributesForItem(at:): 返回指定 indexPath 对应的 cell 的布局属性。
invalidateLayoutOnDataChange(): 手动刷新布局，例如当数据源发生变化时。
优点:

灵活: 可以通过 WaterfallLayoutDelegate 灵活地控制每个 cell 的高度。
性能优化: 使用了高度缓存，提高了布局性能。
可扩展性: 可以根据需要扩展功能，例如支持多列、自定义间距等。*/
