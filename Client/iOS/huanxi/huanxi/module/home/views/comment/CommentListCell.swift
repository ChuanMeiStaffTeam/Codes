//
//  CommentListCell.swift
//  huanxi
//
//  Created by rslz on 2024/11/11.
//

import Foundation
import UIKit


class CommentListCell:UITableViewCell {
    
    static let MaxContentWidth:CGFloat = screenWidth - 55 - 35
    
    var avatar = UIImageView.init(image: UIImage.init(named: "img_find_default"))
    var likeIcon = UIImageView.init(image: UIImage.init(named: "post_unlike"))
    var nickName = UILabel.init()
    var extraTag = UILabel.init()
    var content = UILabel.init()
    var likeNum = UILabel.init()
    var date = UILabel.init()
    var splitLine = UIView.init()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        initSubViews()
    }
    
    func initSubViews() {
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 14
        self.addSubview(avatar)
        
        likeIcon.contentMode = .center
        self.addSubview(likeIcon)
        
        nickName.numberOfLines = 1
        nickName.textColor = UIColor.white_60
        nickName.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(nickName)
        
        content.numberOfLines = 0
        content.textColor = UIColor.white_80
        content.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(content)
        
        date.numberOfLines = 1
        date.textColor = .gray
        date.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(date)
        
        likeNum.numberOfLines = 1
        likeNum.textColor = .gray
        likeNum.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(likeNum)
        
        splitLine.backgroundColor = UIColor.white_10
        self.addSubview(splitLine)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.image = UIImage.init(named: "img_find_default")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatar.snp.makeConstraints { make in
            make.top.left.equalTo(self).inset(15)
            make.width.height.equalTo(28)
        }
        likeIcon.snp.makeConstraints { make in
            make.top.right.equalTo(self).inset(15)
            make.width.height.equalTo(20)
        }
        nickName.snp.makeConstraints { make in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self.avatar.snp.right).offset(10)
            make.right.equalTo(self.likeIcon.snp.left).inset(25)
        }
        content.snp.makeConstraints { make in
            make.top.equalTo(self.nickName.snp.bottom).offset(5)
            make.left.equalTo(self.nickName)
            make.width.lessThanOrEqualTo(CommentListCell.MaxContentWidth)
        }
        date.snp.makeConstraints { make in
            make.top.equalTo(self.content.snp.bottom).offset(5)
            make.left.right.equalTo(self.nickName)
        }
        likeNum.snp.makeConstraints { make in
            make.centerX.equalTo(self.likeIcon)
            make.top.equalTo(self.likeIcon.snp.bottom).offset(5)
        }
        splitLine.snp.makeConstraints { make in
            make.left.equalTo(self.date)
            make.right.equalTo(self.likeIcon)
            make.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    func initData(comment:CommentModel) {
        
//        let user = LoginManager.shared.getUserInfo()
        let defaultAvatar = UIImage(resource: .imgFindDefault)
        
        
//        var avatarUrl:URL?
        if comment.user_type == "user" {
            avatar.kf.setImage(with: URL(string: comment.user?.profilePictureUrl ?? ""), placeholder: defaultAvatar)
            nickName.text = comment.user?.fullName
        } else {
//            avatarUrl = URL.init(string: comment.visitor?.avatar ?? "")
            nickName.text = VisitorModel.formatUDID(udid: comment.visitor?.udid ?? "")
        }
//        avatar.setImageWithURL(imageUrl: avatarUrl!) {[weak self] (image, error) in
//            self?.avatar.image = image?.drawCircleImage()
//        }
        content.text = comment.text
        date.text = Date.formatTime(timeInterval: TimeInterval(comment.create_time ?? 0))
        likeNum.text = String.formatCount(count: comment.digg_count ?? 0)
    }
    
    static func cellHeight(comment:CommentModel) -> CGFloat {
        let attributedString = NSMutableAttributedString.init(string: comment.text ?? "")
        attributedString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], range: NSRange.init(location: 0, length: attributedString.length))
        let size:CGSize = attributedString.multiLineSize(width: MaxContentWidth)
        return size.height + 30 + 30
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
