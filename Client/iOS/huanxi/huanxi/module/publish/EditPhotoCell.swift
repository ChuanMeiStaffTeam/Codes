//
//  EditPhotoCell.swift
//  huanxi
//
//  Created by jack on 2024/3/6.
//

import UIKit

class EditPhotoCell: UICollectionViewCell {
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    let filterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(imgView)
        contentView.addSubview(filterLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        filterLabel.frame = CGRect(x: 0, y: 0, width: width, height: 25)
        imgView.frame = CGRect(x: 3, y: 27, width: 94, height: 94)
        
    }
    
}


/*代码功能

这段 Swift 代码定义了一个名为 EditPhotoCell 的自定义 UICollectionViewCell 类。这个类主要用于在图片编辑功能中显示一张经过滤镜处理的图片，并展示对应的滤镜名称。

代码结构

imgView: 一个 UIImageView，用于显示经过滤镜处理的图片。
filterLabel: 一个 UILabel，用于显示所应用滤镜的名称。
layoutSubviews(): 在这个方法中，设置 imgView 和 filterLabel 在 cell 中的布局。
代码工作原理

初始化:
当创建 EditPhotoCell 实例时，会初始化 imgView 和 filterLabel，并将它们添加到 cell 的内容视图中。
布局:
layoutSubviews() 方法会在 cell 的布局发生变化时调用。在这个方法中，会设置 imgView 和 filterLabel 的位置和大小。
filterLabel 通常位于 cell 的顶部，显示滤镜名称。
imgView 位于 filterLabel 下方，显示经过滤镜处理的图片。
显示:
在 UICollectionView 中，每个 cell 都会显示一个 EditPhotoCell 实例。
通过设置 imgView 的 image 属性和 filterLabel 的 text 属性，可以显示不同的滤镜效果和对应的滤镜名称。
代码作用

这个 EditPhotoCell 类为图片编辑功能提供了一个基本单元。它可以用来展示一系列经过不同滤镜处理的图片，用户可以通过点击不同的 cell 来选择不同的滤镜效果。

可能的改进

自定义: 可以通过自定义 imgView 和 filterLabel 的样式，来实现不同的视觉效果。
交互: 可以添加一些交互功能，比如点击 cell 时显示更多的滤镜信息。
性能优化: 如果处理大量图片，可以考虑使用异步加载图片的方式，提高性能。
总结

 EditPhotoCell 是一个非常简单的自定义 cell，用于显示滤镜效果。它在图片编辑功能中扮演着重要的角色，为用户提供直观的视觉反馈。*/
