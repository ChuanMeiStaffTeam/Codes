//
//  HomeUserItemCell.swift
//  huanxi
//
//  Created by rslz on 2025/1/20.
//

import UIKit

class HomeUserItemCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 32.5
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.postBgColor
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "用户名"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(5)
            make.width.height.equalTo(65)
        }
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-5)
            make.centerX.equalToSuperview().offset(0)
            make.width.greaterThanOrEqualTo(30)
            make.width.lessThanOrEqualTo(65)
            make.height.equalTo(12)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: UserInfoModel? {
        didSet {
            if let urlStr = model?.profilePictureUrl {
                imageView.kf.setImage(with: URL.init(string: urlStr))
            }
            label.text = model?.fullName ?? model?.username
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setLayoutSkeletonLayer()
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
}

// MARK: 骨架屏配置
extension HomeUserItemCell {
    func setLayoutSkeletonLayer() {
        imageView.layoutSkeletonLayer()
        label.layoutSkeletonLayer()
    }
    
    func showSkeletonAnimation() {
        imageView.startSkeletonAnimation()
        label.startSkeletonAnimation()
    }
    
    func closeSkeletonAnimation() {
        imageView.stopSkeletonAnimation()
        label.stopSkeletonAnimation()
    }
}


/*代码功能:

定义了一个用于展示单个用户信息的 UICollectionViewCell 子类 HomeUserItemCell。
它包含用户头像 (imageView) 和用户名 (label) 的 UI 元素。
支持骨架屏动画 (isSkeletonVisible)，在数据加载过程中显示占位效果。
使用 Kingfisher 框架加载用户头像图片。
代码结构:

属性:

imageView: 显示用户头像的 UIImageView。
label: 显示用户名的 UILabel。
model: 一个可选的 UserInfoModel 对象，用于存储用户信息。
isSkeletonVisible: 一个布尔值，控制是否显示骨架屏动画。
方法:

init(frame:): 初始化方法，设置子视图的布局。
required init?(coder aDecoder: NSCoder): 编码器初始化方法，目前不支持。
model: 属性的观察者，当 model 值变化时，更新头像和用户名。
layoutSubviews(): 每次布局更新时调用，用于启动骨架屏动画。
isSkeletonVisible: 属性的观察者，控制骨架屏动画的显示和隐藏。
MARK: 骨架屏配置 (内部实现细节)

setLayoutSkeletonLayer(): 设置骨架屏层的布局。
showSkeletonAnimation(): 开启骨架屏动画。
closeSkeletonAnimation(): 关闭骨架屏动画。
代码逻辑:

初始化: 在 init(frame:) 方法中，设置头像和用户名的样式并添加为子视图，并通过 SnapKit 进行布局。
更新数据: 当 model 属性的值发生变化时，会调用观察者方法，根据 model 中的信息更新头像和用户名。
如果 model.profilePictureUrl 有值，则使用 Kingfisher 框架加载头像图片。
用户名会显示 model.fullName (如果有) 或者 model.username。
骨架屏动画: 通过 isSkeletonVisible 属性控制骨架屏的显示和隐藏。
当 isSkeletonVisible 为真时，会调用 showSkeletonAnimation() 方法开启骨架屏动画，为头像和用户名显示占位效果。
当 isSkeletonVisible 为假时，会调用 closeSkeletonAnimation() 方法关闭骨架屏动画。
总体而言

 这段代码实现了一个可用于展示用户头像和用户名的列表单元格。它使用了 Kingfisher 框架异步加载图片，并支持骨架屏动画提升用户体验。*/
