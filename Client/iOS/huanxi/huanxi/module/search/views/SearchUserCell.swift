//
//  SearchSugUserCell.swift
//  huanxi
//
//  Created by rslz on 2024/12/19.
//

import UIKit
import Kingfisher
import SnapKit

class SearchUserCell: UITableViewCell {
    
    let avatar = UIImageView()
    let nameLabel = UILabel()
    let contentLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update gradientLayer frame after layout has been completed
        self.setLayoutSkeletonLayer()
    }
    
    func setupView() {
        selectionStyle = .none
        backgroundColor = .black
        contentView.backgroundColor = .black
        
        // Avatar setup
        avatar.layer.cornerRadius = 20
        avatar.layer.masksToBounds = true
        avatar.backgroundColor = UIColor.postBgColor
        contentView.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(7)
            make.left.equalToSuperview().offset(12)
            make.height.width.equalTo(40)
        }
        
        // Name Label setup
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 14)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatar.snp.top).offset(5)
            make.left.equalTo(avatar.snp.right).offset(16)
            make.right.lessThanOrEqualToSuperview().inset(16)
            make.width.greaterThanOrEqualTo(UIDevice.screenWidth/3)
            make.height.equalTo(14)
        }
        
        // Content Label setup
        contentLabel.textColor = .init(hexString: "#777777")
        contentLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.bottom.equalTo(avatar.snp.bottom).offset(-5)
            make.left.equalTo(avatar.snp.right).offset(16)
            make.right.lessThanOrEqualToSuperview().inset(16)
            make.width.greaterThanOrEqualTo(UIDevice.screenWidth/2)
            make.height.equalTo(14)
        }
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

    var user: UserInfoModel? {
        didSet {
            if let urlStr = user?.profilePictureUrl {
                if urlStr.contains("http") {
                    avatar.kf.setImage(with: URL(string: urlStr))
                } else {
                    avatar.image = UIImage(named: "main_pic_test")
                }
            }
            nameLabel.text = user?.fullName ?? user?.username
            contentLabel.text = user?.bio ?? user?.email
        }
    }
}


// MARK: 骨架屏配置
extension SearchUserCell {
    func setLayoutSkeletonLayer() {
        avatar.layoutSkeletonLayer()
        nameLabel.layoutSkeletonLayer()
        contentLabel.layoutSkeletonLayer()
    }
    
    func showSkeletonAnimation() {
        avatar.startSkeletonAnimation()
        nameLabel.startSkeletonAnimation()
        contentLabel.startSkeletonAnimation()
    }
    
    func closeSkeletonAnimation() {
        avatar.stopSkeletonAnimation()
        nameLabel.stopSkeletonAnimation()
        contentLabel.stopSkeletonAnimation()
    }
}
