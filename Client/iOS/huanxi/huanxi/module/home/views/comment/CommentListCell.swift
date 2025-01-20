//
//  CommentListCell.swift
//  huanxi
//
//  Created by rslz on 2024/11/11.
//

import Foundation
import UIKit

class CommentListCell: UITableViewCell {
    static let MaxContentWidth: CGFloat = screenWidth - 55 - 35

    var avatar = UIImageView(image: UIImage(named: "img_find_default"))
    var likeIcon = UIImageView(image: UIImage(named: "post_unlike"))
    var nickName = UILabel()
    var extraTag = UILabel()
    var content = UILabel()
    var likeNum = UILabel()
    var dateLabel = UILabel()
    var splitLine = UIView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        initSubViews()
    }

    func initSubViews() {
        avatar.backgroundColor = UIColor.postBgColor
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 14
        addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.top.left.equalTo(self).inset(15)
            make.width.height.equalTo(28)
        }

        likeIcon.contentMode = .center
        likeIcon.isHidden = true
        addSubview(likeIcon)
        likeIcon.snp.makeConstraints { make in
            make.top.right.equalTo(self).inset(15)
            make.width.height.equalTo(20)
        }

        nickName.numberOfLines = 1
        nickName.textColor = UIColor.white_60
        nickName.font = UIFont.systemFont(ofSize: 12)
        addSubview(nickName)
        nickName.snp.makeConstraints { make in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self.avatar.snp.right).offset(10)
            make.right.equalTo(self.likeIcon.snp.left).inset(25)
            make.height.equalTo(12)
        }

        content.numberOfLines = 0
        content.textColor = UIColor.white_80
        content.font = UIFont.systemFont(ofSize: 14)
        addSubview(content)
        content.snp.makeConstraints { make in
            make.top.equalTo(self.nickName.snp.bottom).offset(5)
            make.left.equalTo(self.nickName)
            make.width.lessThanOrEqualTo(CommentListCell.MaxContentWidth)
            make.height.greaterThanOrEqualTo(14)
        }

        dateLabel.numberOfLines = 1
        dateLabel.textColor = .gray
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.content.snp.bottom).offset(5)
            make.left.right.equalTo(self.nickName)
            make.height.equalTo(12)
        }

        likeNum.numberOfLines = 1
        likeNum.textColor = .gray
        likeNum.font = UIFont.systemFont(ofSize: 12)
        likeNum.isHidden = true
        addSubview(likeNum)
        likeNum.snp.makeConstraints { make in
            make.centerX.equalTo(self.likeIcon)
            make.top.equalTo(self.likeIcon.snp.bottom).offset(5)
        }

        splitLine.backgroundColor = UIColor.white_10
        addSubview(splitLine)
        splitLine.snp.makeConstraints { make in
            make.left.equalTo(self.dateLabel)
            make.right.equalTo(self.likeIcon)
            make.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setLayoutSkeletonLayer()
    }

    // 控制骨架屏动画显示或隐藏的变量
    var isSkeletonVisible: Bool = true {
        didSet {
            if isSkeletonVisible {
                // 启动骨架屏动画
                showSkeletonAnimation()
            } else {
                // 停止骨架屏动画
                closeSkeletonAnimation()
            }
        }
    }

    var model: CommentModel? {
        didSet {
            //        let user = LoginManager.shared.getUserInfo()
            let defaultAvatar = UIImage(resource: .imgFindDefault)

            //        var avatarUrl:URL?
//            if model?.sysComment.user_type == "user" {
//                avatar.kf.setImage(with: URL(string: model?.user?.profilePictureUrl ?? ""), placeholder: defaultAvatar)
//                nickName.text = model?.user?.fullName
//            } else {
//                //            avatarUrl = URL.init(string: comment.visitor?.avatar ?? "")
//                nickName.text = VisitorModel.formatUDID(udid: model?.visitor?.udid ?? "")
//            }
            //        avatar.setImageWithURL(imageUrl: avatarUrl!) {[weak self] (image, error) in
            //            self?.avatar.image = image?.drawCircleImage()
            //        }
            
            avatar.kf.setImage(with: URL(string: model?.profilePictureUrl ?? ""), placeholder: defaultAvatar)
            nickName.text = model?.fullName
            
            content.text = model?.sysComment?.commentText
            
            let timestamp = Date.convertToTimestamp(dateString: model?.sysComment?.createdAt ?? "2024-11-12 16:02:02", format: .standard)
            dateLabel.text = Date.formatTime(timeInterval: TimeInterval(timestamp ?? 0))
            
//            date.text = Date.formatTime(timeInterval: TimeInterval(model?.create_time ?? 0))
//            likeNum.text = String.formatCount(count: model?.digg_count ?? 0)
        }
    }

    static func cellHeight(comment: CommentModel) -> CGFloat {
        let attributedString = NSMutableAttributedString(string: comment.sysComment?.commentText ?? "")
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], range: NSRange(location: 0, length: attributedString.length))
        let size: CGSize = attributedString.multiLineSize(width: MaxContentWidth)
        return size.height + 30 + 30
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: 骨架屏配置
extension CommentListCell {
    func setLayoutSkeletonLayer() {
        avatar.layoutSkeletonLayer()
        nickName.layoutSkeletonLayer()
        content.layoutSkeletonLayer()
        dateLabel.layoutSkeletonLayer()
    }

    func showSkeletonAnimation() {
        avatar.startSkeletonAnimation()
        nickName.startSkeletonAnimation()
        content.startSkeletonAnimation()
        dateLabel.startSkeletonAnimation()
    }

    func closeSkeletonAnimation() {
        avatar.stopSkeletonAnimation()
        nickName.stopSkeletonAnimation()
        content.stopSkeletonAnimation()
        dateLabel.stopSkeletonAnimation()
    }
}
