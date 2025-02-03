//
//  WaterfallCollectionView.swift
//  huanxi
//
//  Created by jack on 2024/6/22.
//

import UIKit

class WaterfallCollectionView: BaseView {
    var didSelectItemBlock: ((PostModel?) -> Void)?

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
        collectionView.register(WaterfallCollectionViewCell.self, forCellWithReuseIdentifier: WaterfallCollectionViewCell.defaultReuseIdentifier)
        collectionView.register(SpaceCollectionViewCell.self, forCellWithReuseIdentifier: SpaceCollectionViewCell.defaultReuseIdentifier)

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

    var items: [SearchViewModel.CellType]? {
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
        guard let item = items?.ck_objIndex(indexPath.item) else {
            return collectionView.dequeueReusableCell(forIndexPath: indexPath) as SpaceCollectionViewCell
        }
        
        switch item {
        case .skeleton:
            let cell: WaterfallCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.isSkeletonVisible = true
            return cell
        case .postItem(let post):
            let cell: WaterfallCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.isSkeletonVisible = false
            cell.model = post
            return cell
        default:
            return collectionView.dequeueReusableCell(forIndexPath: indexPath) as SpaceCollectionViewCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = items?.ck_objIndex(indexPath.item) else { return }
        switch item {
        case .postItem(let post):
            if let block = didSelectItemBlock {
                block(post)
            }
        default:
            return
        }

    }
}

extension WaterfallCollectionView: WaterfallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        if let item = items?.ck_objIndex(indexPath.row){
            switch item {
            case .skeleton:
                return CGFloat.random(in: 100...250)
            case .postItem(let post):
                return post.imageHeight ?? 0
            default:
                return 0
            }
        }
        return 0
    }
}


/*代码功能

这段代码定义了一个名为 WaterfallCollectionView 的自定义视图，用于实现瀑布流布局的图片展示。

核心功能

瀑布流布局:
使用 WaterfallFlowLayout 实现瀑布流布局，可以根据图片的实际高度动态调整每个 cell 的高度。
数据展示:
通过 items 属性接收数据源，并根据数据源类型（图片、骨架屏、空状态等）渲染不同的 cell。
点击事件:
支持点击事件，当用户点击图片 cell 时，通过 didSelectItemBlock 回调通知外部。
骨架屏:
集成了骨架屏功能，在加载数据时显示占位符，提升用户体验。
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
相关功能已在之前的分析中详细介绍。
关键概念

瀑布流布局: 是一种不规则的网格布局，每个 cell 的高度不固定，可以根据内容动态调整。
数据源: items 数组存储了要展示的数据，包括图片数据、骨架屏数据、空状态数据等。
骨架屏: 在数据加载过程中显示占位符，提升用户体验。
委托协议: WaterfallLayoutDelegate 协议用于计算每个 cell 的高度。
总结

 WaterfallCollectionView 是一个功能较为完善的自定义视图，用于实现瀑布流布局的图片展示。它结合了瀑布流布局、数据绑定、骨架屏动画等技术，提供了良好的用户体验。*/
