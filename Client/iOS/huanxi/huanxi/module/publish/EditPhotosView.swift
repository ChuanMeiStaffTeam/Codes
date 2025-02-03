//
//  EditPhotosView.swift
//  huanxi
//
//  Created by jack on 2024/3/24.
//

import UIKit
import SwiftUI

class EditPhotosView: UIView {
    
    var didSelectedItemBlock: ((Int) ->Void)?
    var currentIndex = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
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
        let width = .screenWidth - 32 - 40
        layout.itemSize = CGSize(width: width, height: width)
        
        let collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: CGFloat.screenWidth, height: .screenWidth - 32), collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(EditPhotosCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        return collectionView
    }()
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        let width = .screenWidth - 32
        imageView.frame = CGRect.init(x: 16, y: 0, width: width, height: width)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.mainBlueColor.cgColor
        imageView.layer.borderWidth = 2.0
        return imageView
    }()
}

extension EditPhotosView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! EditPhotosCell
        let image = images[indexPath.row]
        cell.imgView.image = image
        
        cell.showBorder(hidden: !(currentIndex==indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let block = didSelectedItemBlock {
            block(indexPath.row)
        }
        
        
        if indexPath.row == images.count - 1 {
            let offsetX = collectionView.contentSize.width
            collectionView.setContentOffset(CGPoint.init(x: offsetX-CGFloat.screenWidth, y: 9), animated: true)
        } else {
            if indexPath.row == 0 {
                collectionView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            } else {
                let width = .screenWidth - 32 - 40
                let offsetX = (width + 16) + (CGFloat(indexPath.row) - 1) * (width + 10)
                collectionView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return edgeInsets
    }
}


class EditPhotosCell: UICollectionViewCell {
    
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
    
    func showBorder(hidden: Bool) {
        if hidden {
            imgView.layer.borderColor = UIColor.clear.cgColor
            imgView.layer.borderWidth = 0.0
        } else {
            imgView.layer.borderColor = UIColor.mainBlueColor.cgColor
            imgView.layer.borderWidth = 2.0
        }
        
    }
    
}


/*这段代码定义了一个名为 EditPhotosView 的自定义 UIView 组件，用于展示一组图片，并允许用户进行选择。

主要特点

单图/多图展示:

如果 images 数组中只有一张图片，则会将该图片居中显示在一个 UIImageView 中，并添加边框。
如果有多张图片，则会使用 UICollectionView 水平滚动显示这些图片。
图片展示:

使用 UICollectionView 来展示多张图片，可以自定义间距和滚动方向。
每个图片都显示在 EditPhotosCell 中，并具有圆角和裁剪功能。
突出显示当前选中的图片，为其添加边框。
用户交互:

提供了一个 didSelectedItemBlock 闭包，用于在用户选择图片时通知父视图控制器。
处理在 UICollectionView 中选择图片的事件，并平滑地滚动 collectionView 使选中的图片居中。
布局自定义:

可以自定义 UICollectionView 的布局，例如单元格大小、间距和滚动方向。
代码结构

EditPhotosView 类

属性:
images: 存储要显示的图片数组。
currentIndex: 当前选中的图片索引。
didSelectedItemBlock: 用于通知父视图控制器图片被选中的闭包。
collectionView: 用于显示多张图片的 UICollectionView。
imgView: 用于显示单张图片的 UIImageView。
方法:
init(): 初始化视图，设置子视图。
images 属性的 didSet 观察器：根据图片数量决定是显示单张图片还是多张图片。
collectionView(_:numberOfItemsInSection:): 返回 images 数组中图片的数量。
collectionView(_:cellForItemAt:): 创建并配置 EditPhotosCell，为当前选中的图片添加边框。
collectionView(_:didSelectItemAt:): 处理图片选择事件，更新 currentIndex，调用 didSelectedItemBlock 闭包，并平滑滚动 collectionView。
collectionView(_:layout:insetForSectionAt:): 设置 collectionView 的边距。
EditPhotosCell 类

属性:
imgView: 用于显示图片的 UIImageView。
方法:
showBorder(hidden:): 根据选中状态控制单元格边框的显示和颜色。
关键改进

平滑滚动: 代码实现了平滑滚动 collectionView 使选中的图片居中，提升了用户体验。
边框指示: EditPhotosCell 类提供了 showBorder 函数，用于视觉上指示当前选中的图片。
布局自定义: 可以灵活调整 UICollectionView 的布局，例如单元格大小、间距和滚动方向。
总结

 这段代码实现了一个功能完善、易于使用的图片展示和选择组件。它可以很好地适应不同的展示需求，并提供了良好的用户交互体验。*/
