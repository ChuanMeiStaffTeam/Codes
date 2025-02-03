//
//  HemeRecommendItemCell.swift
//  huanxi
//
//  Created by rslz on 2025/1/20.
//

import UIKit

class HemeRecommendItemCell: BaseCollectionViewCell {
    
    var onTap: (() -> Void)?

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 74
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.postBgColor
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .init(hexString: "#7F7F7F")
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    let followButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .init(hexString: "#0098FD")
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.setTitle("关注", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(18)
            make.height.width.equalTo(148)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(10)
        }
        
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        contentView.addSubview(followButton)
        followButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(180)
            make.height.equalTo(30)
        }
        
        followButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.onTap?()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: UserInfoModel? {
        didSet {
            if let urlStr = model?.profilePictureUrl {
                avatarImageView.kf.setImage(with: URL.init(string: urlStr))
            }
            nameLabel.text = model?.fullName ?? model?.username
            tagLabel.text = "热门"
            followButton.setTitle("关注", for: .normal)
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
extension HemeRecommendItemCell {
    func setLayoutSkeletonLayer() {
        avatarImageView.layoutSkeletonLayer()
        nameLabel.layoutSkeletonLayer()
    }
    
    func showSkeletonAnimation() {
        avatarImageView.startSkeletonAnimation()
        nameLabel.startSkeletonAnimation()
    }
    
    func closeSkeletonAnimation() {
        avatarImageView.stopSkeletonAnimation()
        nameLabel.stopSkeletonAnimation()
    }
}

/*代码功能：

这个 Swift 代码文件定义了一个名为 HemeRecommendItemCell 的自定义 UICollectionViewCell 子类，主要用于在推荐列表中展示单个用户的卡片信息。这个单元格包含了用户的头像、用户名、标签和关注按钮等元素。

代码结构：

属性:

onTap: 一个闭包，用于在点击单元格时触发自定义操作。
avatarImageView: 用于显示用户头像的 UIImageView。
nameLabel: 用于显示用户名称的 UILabel。
tagLabel: 用于显示用户标签的 UILabel。
followButton: 关注按钮，用户点击后可以执行关注操作。
model: 一个可选的 UserInfoModel 对象，用于存储用户信息。
isSkeletonVisible: 一个布尔值，用于控制骨架屏动画的显示和隐藏。
方法:

init(frame:): 初始化方法，设置子视图的布局。
reloadData(name:imageStr:): 用于更新单元格的数据，包括头像、用户名和标签。
followButtonTapped: 关注按钮的点击事件处理函数。
isSkeletonVisible: 属性的观察者，控制骨架屏动画的显示和隐藏。
代码逻辑:

初始化: 在 init(frame:) 方法中，设置子视图的样式和布局。
数据绑定: 当 model 属性的值发生变化时，会调用观察者方法，根据 model 中的信息更新头像、用户名和标签。
骨架屏动画: 通过 isSkeletonVisible 属性控制骨架屏的显示和隐藏。
当 isSkeletonVisible 为真时，会调用 showSkeletonAnimation() 方法开启骨架屏动画，为头像和用户名显示占位效果。
当 isSkeletonVisible 为假时，会调用 closeSkeletonAnimation() 方法关闭骨架屏动画。
关注按钮点击: 当点击 followButton 时，会触发 onTap 闭包，可以执行自定义的关注逻辑。
关键点:

自定义单元格: 通过继承 UICollectionViewCell 来创建自定义的单元格。
布局: 使用 SnapKit 来布局子视图，方便灵活。
数据绑定: 通过 model 属性和观察者来更新单元格的数据。
骨架屏: 使用骨架屏来提升用户体验，在数据加载过程中显示占位效果。
RxSwift: 使用 RxSwift 的 rx.tapThrottle 来处理按钮点击事件，避免频繁触发。

总结:

 这段代码实现了一个功能完善的 UICollectionViewCell，可以用于展示推荐用户的信息。它具有良好的可扩展性和可维护性，可以根据需求进行定制。*/
