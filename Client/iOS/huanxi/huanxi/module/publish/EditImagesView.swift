//
//  ExplainImagesView.swift
//  huanxi
//
//  Created by jack on 2024/3/24.
//

import UIKit

class ExplainImagesView: UIView {
    
    var images: [UIImage] = [] {
        didSet {
            if images.count == 1 {
                collectionView.isHidden = true
                imgView.isHidden = false
                let image = images.first
                imgView.image = image
            } else {
                collectionView.isHidden = false
                imgView.isHidden = true
                collectionView.reloadData()
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        addSubview(collectionView)
        addSubview(imgView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let cellIdentifier = "imageCell"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 250, height: 250)
        
        let collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: CGFloat.screenWidth, height: 250), collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ExplainImageCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        return collectionView
    }()
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect.init(x: CGFloat.screenWidth / 2.0 - 125, y: 0, width: 250, height: 250)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
}

extension ExplainImagesView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ExplainImageCell
        let image = images[indexPath.row]
        cell.imgView.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return edgeInsets
    }
}


class ExplainImageCell: UICollectionViewCell {
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(imgView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        
    }
    
}
/*代码功能概览
 
 这段代码主要实现了一个用于展示图片的视图组件 ExplainImagesView。它可以根据提供给它的图片数组，灵活地展示一张或多张图片。

 代码主要模块及功能

 ExplainImagesView 类:

 属性:
 images: 用于存储要展示的图片数组。
 collectionView: 一个 UICollectionView，用于展示多张图片。
 imgView: 一个 UIImageView，用于展示单张图片。
 方法:
 didSet 观察者：当 images 数组发生变化时，根据图片数量决定是显示 collectionView 还是 imgView。
 collectionView 和 imgView 的初始化与布局：根据图片数量动态切换显示方式。
 ExplainImageCell 类:

 作用: 作为 UICollectionView 的子单元，用于展示单个图片。
 属性:
 imgView: 用于显示图片的 UIImageView。
 功能:
 初始化并配置 UIImageView。
 代码逻辑

 当 ExplainImagesView 初始化时，会创建 collectionView 和 imgView，但初始状态下都处于隐藏状态。
 当 images 属性被赋值时，会根据图片数量决定显示哪个视图：
 如果只有一张图片，则隐藏 collectionView，显示 imgView，并将图片设置给 imgView。
 如果有多张图片，则隐藏 imgView，显示 collectionView，并重新加载 collectionView 的数据。
 collectionView 的数据源和代理方法负责配置每个 cell 的内容，即显示对应的图片。
 代码亮点

 灵活的布局: 可以根据图片数量自动切换显示方式，适应不同的场景。
 可复用性: ExplainImagesView 可以作为一个独立的组件，方便在其他地方复用。
 代码简洁清晰: 代码结构清晰，易于理解。
 潜在改进

 图片加载优化: 可以考虑异步加载图片，避免卡顿。
 缓存机制: 可以引入缓存机制，提高性能，减少重复加载。
 自定义样式: 可以提供更多的自定义选项，比如图片间距、圆角大小等。
 错误处理: 可以添加错误处理，比如图片加载失败的情况。
 总结

 这段代码实现了一个功能简单、易于使用的图片展示组件。通过对 images 属性的监听，可以动态地调整视图的显示方式，以适应不同的数据情况。*/
