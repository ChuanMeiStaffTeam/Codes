//
//  MainContentCell.swift
//  huanxi
//
//  Created by jack on 2024/2/28.
//

import UIKit
import Lottie

protocol MainContentCellDelegate: AnyObject {
    func didClickMore(_ data: PostModel, indexPath: IndexPath?)
    
    func didClickLike(_ data: PostModel, indexPath: IndexPath?)
    
    func didClickComment(_ data: PostModel)
    
    func didClickShare(_ data: PostModel)
    
    func didClickMark(_ data: PostModel, indexPath: IndexPath?, markComplete:((Bool)->Void)?)
}

class MainContentCell: UITableViewCell {
    
    weak var delegate: MainContentCellDelegate?
    
    let avatar = UIImageView()
    let nameLabel = UILabel()
    let countryLabel = UILabel()
    let moreBtn = UIButton()
    let imgView = UIImageView()
    let likeBtn = UIButton()
    let commentBtn = UIButton()
    let shareBtn = UIButton()
    let collectBtn = UIButton()
    let floatingLabel = PaddedLabel() // 浮层提示
    let likeNumLabel = UILabel()
    let contentLabel = UILabel()
    let dateLabel = UILabel()
    let likeAnimationView = LottieAnimationView(name: "heart")


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.playLikeAnimation))
        doubleTap.numberOfTapsRequired = 2
        imgView.addGestureRecognizer(doubleTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: PostModel? {
        didSet {
            if let urlStr = model?.user?.profilePictureUrl {
                if urlStr.contains("http") {
                    avatar.kf.setImage(with: URL.init(string: urlStr))
                } else {
                    avatar.image = UIImage.init(named: urlStr)
                }
            } else {
                avatar.image = UIImage.init(named: "main_pic_test")
            }
            
            nameLabel.text = model?.user?.fullName ?? model?.user?.username
            if let urlStr = model?.images?.first?.imageUrl {
                if urlStr.contains("http") {
                    imgView.kf.setImage(with: URL.init(string: urlStr))
                } else {
                    imgView.image = UIImage.init(named: urlStr)
                }
            }
            countryLabel.text = model?.location
            likeNumLabel.text = String(format: "%d次点赞", model?.likesCount ?? 0)
            contentLabel.text = model?.caption
            
            let timestamp = Date.convertToTimestamp(dateString: model?.createdAt ?? "2024-11-12 16:02:02", format: .standard)
            dateLabel.text = Date.formatTime(timeInterval: TimeInterval(timestamp ?? 0))
            
            likeBtn.setImage(UIImage.init(named: (model?.liked ?? false) ? "post_like" : "post_unlike"), for: .normal)
            collectBtn.isSelected = model?.favorite ?? false
        }
    }
    
    var indexPath: IndexPath? {
        didSet {
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
    
    func setupView() {
        
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(avatar)
        contentView.addSubview(nameLabel)
        contentView.addSubview(countryLabel)
        contentView.addSubview(moreBtn)
        contentView.addSubview(imgView)
        contentView.addSubview(likeBtn)
        contentView.addSubview(commentBtn)
        contentView.addSubview(shareBtn)
        contentView.addSubview(collectBtn)
        contentView.addSubview(likeNumLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
        imgView.addSubview(floatingLabel)
        imgView.addSubview(likeAnimationView)

        
        avatar.backgroundColor = UIColor.postBgColor
        avatar.layer.cornerRadius = 16
        avatar.layer.masksToBounds = true
        avatar.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(avatar.snp.right).offset(10)
            make.right.lessThanOrEqualToSuperview().inset(10)
            make.width.greaterThanOrEqualTo(UIDevice.screenWidth/5)
            make.height.equalTo(15)

        }
        
        countryLabel.textColor = .white
        countryLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        countryLabel.snp.makeConstraints { make in
            make.left.equalTo(avatar.snp.right).offset(10)
            make.bottom.equalTo(avatar.snp.bottom).offset(0)
            make.right.lessThanOrEqualToSuperview().inset(10)
            make.width.greaterThanOrEqualTo(UIDevice.screenWidth/4)
            make.height.equalTo(14)
        }
        
        moreBtn.setImage(UIImage.init(named: "main_more"), for: .normal)
        moreBtn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        moreBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(24)
            make.top.equalToSuperview().offset(14)
        }
        
        imgView.backgroundColor = UIColor.postBgColor
        imgView.isUserInteractionEnabled = true
        imgView.clipsToBounds = true
        imgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(52)
            make.height.equalTo(410)
        }
        

        likeBtn.setImage(UIImage.init(named: "post_unlike"), for: .normal)
        likeBtn.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        likeBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(24)
            make.top.equalTo(imgView.snp.bottom).offset(10)
        }
        
        commentBtn.setImage(UIImage.init(named: "main_comment"), for: .normal)
        commentBtn.addTarget(self, action: #selector(commentAction), for: .touchUpInside)
        commentBtn.snp.makeConstraints { make in
            make.left.equalTo(likeBtn.snp.right).offset(16)
            make.width.height.equalTo(24)
            make.top.equalTo(imgView.snp.bottom).offset(10)
        }
        
        shareBtn.setImage(UIImage.init(named: "main_relay"), for: .normal)
        shareBtn.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        shareBtn.snp.makeConstraints { make in
            make.left.equalTo(commentBtn.snp.right).offset(16)
            make.width.height.equalTo(24)
            make.top.equalTo(imgView.snp.bottom).offset(10)
        }
        
        collectBtn.setImage(UIImage.init(named: "post_collect"), for: .normal)
        collectBtn.setImage(UIImage.init(named: "post_collected"), for: .selected)
        collectBtn.addTarget(self, action: #selector(collectAction), for: .touchUpInside)
        collectBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.width.height.equalTo(24)
            make.top.equalTo(imgView.snp.bottom).offset(10)
        }
        
        likeNumLabel.textColor = .white
        likeNumLabel.font = .systemFont(ofSize: 14)
        likeNumLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.right.lessThanOrEqualToSuperview().inset(10)
            make.top.equalTo(collectBtn.snp.bottom).offset(16)
            make.width.greaterThanOrEqualTo(UIDevice.screenWidth/4)
            make.height.equalTo(14)
        }
        
        contentLabel.textColor = .white
        contentLabel.numberOfLines = 3
        contentLabel.font = .systemFont(ofSize: 14)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(likeNumLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.lessThanOrEqualTo(50)
            make.height.greaterThanOrEqualTo(14)

        }
        
        dateLabel.textColor = .init(white: 1, alpha: 0.5)
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.right.lessThanOrEqualToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-3)
            make.width.greaterThanOrEqualTo(UIDevice.screenWidth/4)
            make.height.equalTo(14)
        }
        
        
        // 配置浮层提示
        floatingLabel.text = "已保存到收藏"
        floatingLabel.textColor = UIColor.postBlueColor
        floatingLabel.backgroundColor = UIColor.postBgColor
        floatingLabel.textAlignment = .left
        likeNumLabel.font = .systemFont(ofSize: 14)
        floatingLabel.padding = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 16) // 设置内边距
        floatingLabel.transform = CGAffineTransform(translationX: 0, y: 40) // 初始下移位置
        floatingLabel.snp.makeConstraints({ make in
            make.left.right.equalTo(imgView)
            make.bottom.equalTo(imgView)
            make.height.equalTo(40)
        })
        
        // 点赞动画
        likeAnimationView.contentMode = .scaleAspectFit
        likeAnimationView.loopMode = .playOnce // 播放一次
        likeAnimationView.animationSpeed = 1.0 // 动画速度
        likeAnimationView.snp.makeConstraints({ make in
            make.height.width.equalTo(120)
            make.center.equalTo(imgView)
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update gradientLayer frame after layout has been completed
        self.setLayoutSkeletonLayer()
    }
    
    @objc func moreAction() {
        if let delegate = self.delegate {
            delegate.didClickMore(model ?? PostModel(liked: false), indexPath: indexPath)
        }
    }
    
    
    @objc func collectAction() {
        if let delegate = self.delegate {
            delegate.didClickMark(model ?? PostModel(liked: false), indexPath: indexPath) {[weak self] favorite in
                guard let `self` = self else { return }
                if favorite {
                    DispatchQueue.main.async {
                        self.showFloatingLabel()
                    }
                }
            }
        }
    }
    
    @objc func likeAction() {
        if let delegate = self.delegate {
            delegate.didClickLike(model ?? PostModel(liked: false), indexPath: indexPath)
        }
    }

    
    // 播放点赞动画
    @objc private func playLikeAnimation() {
        likeAnimationView.play { (finished) in
            if finished {
                if !(self.model?.liked ?? false) {
                    if let delegate = self.delegate {
                        delegate.didClickLike(self.model ?? PostModel(liked: false), indexPath: self.indexPath)
                    }
                }
            }
        }
    }
    
    @objc func commentAction() {
        PostCommentPopView.init(postId: model?.postId ?? 0).show(model ?? PostModel(liked: false))

    }
    
    @objc func shareAction() {
//        PostSharePopView.init().show(model ?? PostModel(liked: false), img: imgView.image ?? UIImage(resource: .iconLogo))
        if let urlStr = model?.images?.first?.imageUrl {
            Tools.systemShareAction(text: model?.caption ?? "", url: urlStr, img: imgView.image ?? UIImage(resource: .iconLogo), sourceView: self)
        }
    }

    
    // 帖子上方的浮层动画
    func showFloatingLabel() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
             self.floatingLabel.transform = .identity // 回到原始位置
         }) { _ in
             UIView.animate(withDuration: 0.3, delay: 1.5, options: .curveEaseIn, animations: {
                 self.floatingLabel.transform = CGAffineTransform(translationX: 0, y: 40)
             }, completion: nil)
         }
    }

}

// MARK: 骨架屏配置
extension MainContentCell {
    func setLayoutSkeletonLayer() {
        avatar.layoutSkeletonLayer()
        nameLabel.layoutSkeletonLayer()
        countryLabel.layoutSkeletonLayer()
        imgView.layoutSkeletonLayer()
        likeNumLabel.layoutSkeletonLayer()
        contentLabel.layoutSkeletonLayer()
        dateLabel.layoutSkeletonLayer()
    }
    
    func showSkeletonAnimation() {
        avatar.startSkeletonAnimation()
        nameLabel.startSkeletonAnimation()
        countryLabel.startSkeletonAnimation()
        imgView.startSkeletonAnimation()
        likeNumLabel.startSkeletonAnimation()
        contentLabel.startSkeletonAnimation()
        dateLabel.startSkeletonAnimation()
    }
    
    func closeSkeletonAnimation() {
        avatar.stopSkeletonAnimation()
        nameLabel.stopSkeletonAnimation()
        countryLabel.stopSkeletonAnimation()
        imgView.stopSkeletonAnimation()
        likeNumLabel.stopSkeletonAnimation()
        contentLabel.stopSkeletonAnimation()
        dateLabel.stopSkeletonAnimation()
    }
}
