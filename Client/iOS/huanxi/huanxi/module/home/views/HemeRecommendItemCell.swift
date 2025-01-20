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

