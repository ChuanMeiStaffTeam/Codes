//
//  WaterfallCollectionViewCell.swift
//  huanxi
//
//  Created by jack on 2024/6/22.
//

import UIKit

class WaterfallCollectionViewCell: UICollectionViewCell {
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update gradientLayer frame after layout has been completed
        imgView.frame = contentView.bounds
        self.setLayoutSkeletonLayer()
    }
    
    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(imgView)
        imgView.backgroundColor = UIColor.postBgColor
    }

    // 控制骨架屏动画显示或隐藏的变量
    var isSkeletonVisible: Bool = true {
        didSet {
            if isSkeletonVisible {
                // 启动骨架屏动画
                self.showSkeletonAnimation()
            } else {
                // 停止骨架屏动画
                self.closeSkeletonAnimation()
            }
        }
    }
    
    var model: PostModel? {
        didSet {
            if let urlStr = model?.images?.first?.imageUrl {
                if urlStr.contains("http") {
                    imgView.kf.setImage(with: URL.init(string: urlStr))
                } else {
                    imgView.image = UIImage.init(named: urlStr)
                }
            }
        }
    }
}


// MARK: 骨架屏配置
extension WaterfallCollectionViewCell {
    func setLayoutSkeletonLayer() {
        imgView.layoutSkeletonLayer()
    }
    
    func showSkeletonAnimation() {
        imgView.startSkeletonAnimation()
    }
    
    func closeSkeletonAnimation() {
        imgView.stopSkeletonAnimation()
    }
}


/*代码功能

这段代码定义了一个名为 WaterfallCollectionViewCell 的自定义 UICollectionViewCell 类，用于在瀑布流布局的 UICollectionView 中展示图片。

主要特点

图片展示:
包含一个 UIImageView (imgView) 用于显示图片。
骨架屏效果:
集成了骨架屏动画，在加载图片时显示占位符，提升用户体验。
布局:
layoutSubviews() 方法中调整 imgView 的大小和位置，以适应瀑布流布局。
数据绑定:
通过 model 属性绑定数据，当 model 发生变化时，自动更新显示的图片。
代码结构

imgView: 一个 UIImageView，用于显示图片。
isSkeletonVisible: 布尔值，控制骨架屏动画的显示与隐藏。
model: 存储 PostModel 对象，用于绑定数据。
layoutSubviews(): 调整 imgView 的大小和位置，并调用 setLayoutSkeletonLayer() 方法。
setupViews(): 初始化视图，设置背景色和添加子视图。
骨架屏相关方法:
setLayoutSkeletonLayer()：设置骨架屏的布局。
showSkeletonAnimation()：启动骨架屏动画。
closeSkeletonAnimation()：停止骨架屏动画。
工作原理

初始化:
在 init(frame:) 方法中，初始化视图，设置背景色，并添加 imgView 作为子视图。
布局:
在 layoutSubviews() 方法中，根据 cell 的大小调整 imgView 的大小和位置，并调用 setLayoutSkeletonLayer() 方法设置骨架屏的布局。
数据绑定:
当 model 属性发生变化时，根据 model 中的图片 URL 更新 imgView 的图像。
骨架屏动画:
isSkeletonVisible 属性控制骨架屏动画的显示与隐藏。
当 isSkeletonVisible 为 true 时，调用 showSkeletonAnimation() 启动骨架屏动画。
当 isSkeletonVisible 为 false 时，调用 closeSkeletonAnimation() 停止骨架屏动画。
应用场景

该 cell 适用于瀑布流布局的 UICollectionView，用于展示图片列表。
可以用于社交媒体、电商等需要展示大量图片的应用。
可能的改进

图片加载优化: 可以使用异步加载图片的方式，避免阻塞主线程。
缓存机制: 可以引入缓存机制，提高图片加载速度。
自定义骨架屏: 可以自定义骨架屏的样式，使其与应用的 UI 风格更加一致。
总结

 WaterfallCollectionViewCell 是一个功能较为完善的自定义 cell，适用于瀑布流布局的图片展示场景。它结合了图片加载和骨架屏动画，提供了良好的用户体验。*/
