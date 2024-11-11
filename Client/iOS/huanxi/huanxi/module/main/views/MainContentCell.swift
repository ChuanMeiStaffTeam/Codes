//
//  MainContentCell.swift
//  huanxi
//
//  Created by jack on 2024/2/28.
//

import UIKit
import Lottie

protocol MainContentCellDelegate: AnyObject {
    func didClickMore(_ data: PostModel)
    
    func didClickLike(_ data: PostModel)
    
    func didClickComment(_ data: PostModel)
    
    func didClickShare(_ data: PostModel)
    
    func didClickMark(_ data: PostModel)
}

class MainContentCell: UITableViewCell {
    
    static let identifier = "MainContentCell"  // 标识符，用于复用
    weak var delegate: MainContentCellDelegate?
    var postModel: PostModel = PostModel(liked: false, collected: false)
    
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
    
    
    func configure(post: PostModel){
        postModel = post
        if let urlStr = post.user?.profilePictureUrl {
            avatar.image = UIImage.init(named: urlStr)
        }
        nameLabel.text = post.user?.fullName
        if let urlStr = post.images?.first?.imageUrl {
            imgView.image = UIImage.init(named: urlStr)
        }
        countryLabel.text = post.location
        likeNumLabel.text = String(format: "%d次点赞", post.likesCount ?? 0)
        contentLabel.text = post.caption
        dateLabel.text = post.createdAt
        
        likeBtn.setImage(UIImage.init(named: postModel.liked ? "post_like" : "post_unlike"), for: .normal)
        collectBtn.isSelected = postModel.collected

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

        
        avatar.image = UIImage.init(named: "main_pic_test")
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
        }
        
        countryLabel.textColor = .white
        countryLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        countryLabel.snp.makeConstraints { make in
            make.left.equalTo(avatar.snp.right).offset(10)
            make.bottom.equalTo(avatar.snp.bottom).offset(0)
        }
        
        moreBtn.setImage(UIImage.init(named: "main_more"), for: .normal)
        moreBtn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        moreBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(24)
            make.top.equalToSuperview().offset(14)
        }
        
        imgView.image = UIImage.init(named: "main_pic_test")
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
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(collectBtn.snp.bottom).offset(16)
        }
        
        contentLabel.textColor = .white
        contentLabel.font = .systemFont(ofSize: 14)
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(16)
            make.top.equalTo(likeNumLabel.snp.bottom).offset(10)
        }
        
        dateLabel.textColor = .init(white: 1, alpha: 0.5)
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-3)
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
    
    
    
    @objc func moreAction() {
//        HUDHelper.showToast("点击了更多")
//        if let delegate = self.delegate {
//            delegate.didClickMore(model)
//        }
    }
    
    @objc func likeAction() {
        likeBtn.setImage(UIImage.init(named: postModel.liked ? "post_like" : "post_unlike"), for: .normal)
        postModel.liked = !postModel.liked
        if let delegate = self.delegate {
            delegate.didClickLike(postModel)
        }
    }

    
    // 播放点赞动画
    @objc private func playLikeAnimation() {
        likeAnimationView.play { (finished) in
            if finished {
                if !self.postModel.liked {
                    self.likeBtn.setImage(UIImage.init(named: "post_like"), for: .normal)
                    self.postModel.liked = true
                    if let delegate = self.delegate {
                        delegate.didClickLike(self.postModel)
                    }
                }
            }
        }
    }
    
    @objc func commentAction() {
        PostCommentPopView.init(awemeId: "099").show(self.postModel)

    }
    
    @objc func shareAction() {
        PostSharePopView.init().show(self.postModel)
    }
    
    @objc func collectAction() {
        collectBtn.isSelected.toggle()
        postModel.collected = collectBtn.isSelected
        if collectBtn.isSelected {
            showFloatingLabel()
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

