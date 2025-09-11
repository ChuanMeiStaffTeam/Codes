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
    
    func didClickAvatar(_ data: PostModel)

    func didClickMark(_ data: PostModel, indexPath: IndexPath?, markComplete:((Bool)->Void)?)
}

class MainContentCell: BaseTableViewCell {
    
    weak var delegate: MainContentCellDelegate?
    
    let avatar = UIImageView()
    let nameLabel = UILabel()
    let countryLabel = UILabel()
    let userTapView = UIView()
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
    
        userTapView.rx.tapGestureThrottle().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            if let delegate = self.delegate {
                delegate.didClickAvatar(model ?? PostModel(liked: false))
            }
        }).disposed(by: disposeBag)
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
        contentView.addSubview(userTapView)
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
        
        userTapView.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(avatar)
            make.width.equalTo(UIDevice.screenWidth / 2)
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
        imgView.contentMode = .scaleAspectFill
        imgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(52)
            if traitCollection.horizontalSizeClass == .regular {
                // iPad 大边距
                make.height.equalTo(500)
            } else {
                // iPhone 小边距
                make.height.equalTo(410)
            }
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


/*1. 代码的功能

这段代码定义了一个名为 MainContentCell 的类，这个类是用来在 iOS 应用中显示社交媒体帖子（或类似内容）的自定义 UITableViewCell。它负责创建帖子单元格的 UI 界面，处理用户交互（点赞、评论、分享等），以及与其他部分的代码进行通信。

2. 代码的结构

协议： MainContentCellDelegate 协议定义了 cell 与其他对象之间通信的接口，比如点击事件的回调。
类： MainContentCell 类是主要的逻辑实现部分，包含 UI 元素的创建、布局、数据绑定和事件处理。
属性：
model: 表示一个帖子模型，包含帖子的各种信息。
delegate: 弱引用到实现了 MainContentCellDelegate 协议的对象。
其他属性用于表示 UI 元素，如头像、用户名、帖子内容等。
方法：
setupView: 初始化 UI 元素和布局。
moreAction, collectAction, likeAction, commentAction, shareAction: 处理用户交互事件。
playLikeAnimation: 播放点赞动画。
showFloatingLabel: 显示收藏成功的浮层提示。
setLayoutSkeletonLayer, showSkeletonAnimation, closeSkeletonAnimation: 控制骨架屏动画。
3. 代码的逻辑

数据绑定： 当 model 属性被赋值时，UI 元素会根据 model 中的数据进行更新。
用户交互： 通过 @objc 方法来响应用户的点击事件，并调用相应的 delegate 方法。
动画： 使用 Lottie 动画库来实现点赞动画。
骨架屏： 使用 SkeletonView 库来实现骨架屏效果，在数据加载过程中显示占位图。
4. 用到的技术

UIKit： 用于创建 UI 元素和处理用户交互。
SnapKit： 用于自动布局。
Lottie： 用于播放动画。
SkeletonView： 用于实现骨架屏效果。
Delegate 模式： 用于解耦模块。
更详细的分析需要您提供更多的上下文信息。

如果您能提供以下信息，我将能给您更准确、全面的回答：

PostModel 的结构： 这个模型包含哪些属性？
SkeletonView 的具体用法： 如何在项目中配置和使用？
PaddedLabel 是自定义的控件吗？它的作用是什么？
Tools.systemShareAction 是什么方法？它实现了什么功能？
一些可能的问题和改进建议：

代码可读性： 可以考虑使用更具描述性的变量名和注释来提高代码的可读性。
错误处理： 可以添加更多的错误处理，比如网络请求失败、数据解析错误等。
性能优化： 可以对一些耗时操作进行优化，比如图片加载、动画效果等。
 可测试性： 可以增加单元测试，提高代码的稳定性和可靠性。*/
