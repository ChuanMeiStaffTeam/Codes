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
