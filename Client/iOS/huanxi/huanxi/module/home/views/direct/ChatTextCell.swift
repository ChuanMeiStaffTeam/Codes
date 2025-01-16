//
//  ChatTextCell.swift
//  huanxi
//
//  Created by Jack on 2024/6/7.
//

import UIKit
import NIMSDK
import Kingfisher

class ChatTextCell: UITableViewCell {
    
    var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var constainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = ChatMessageManager.chatTextFont
        return label
    }()
    
    var message: NIMMessage? {
        didSet {
            if let user = NIMSDK.shared().userManager.userInfo(message?.from ?? "") {
                let nickname = user.userInfo?.nickName ?? "Unknown"
                if let avatarUrl = user.userInfo?.avatarUrl {
                    iconView.kf.setImage(with: URL(string: avatarUrl))
                }
                
                nameLabel.text = nickname

            }
//            messageLabel.text = message?.text
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            
            // 创建属性字典
            let attributes: [NSAttributedString.Key: Any] = [
                .font: ChatMessageManager.chatTextFont,
                .paragraphStyle: paragraphStyle
            ]
            let attributeString = NSAttributedString(string: message?.text ?? "", attributes: attributes)
            messageLabel.attributedText = attributeString
            
            layoutSubviews()
        }
    }
    
    var labelWidth: CGFloat = 0.0 {
        didSet {
            layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let currentUserID = NIMSDK.shared().loginManager.currentAccount()
//        if currentUserID == message?.from {
//            iconView.frame = CGRectMake(self.width - 60, 5, 40, 40)
//            nameLabel.frame = CGRectMake(0, 5, self.width - 70, 15)
//            nameLabel.textAlignment = .right
//            constainerView.frame = CGRectMake(self.width - labelWidth - 10 - 70, 25, labelWidth + 10, self.height - 30)
//            let color = UIColor.init(red: 27 / 255.0, green: 188 / 255.0, blue: 155 / 255.0, alpha: 1)
//            constainerView.backgroundColor = .mainBlueColor
//            iconView.image = UIImage(named: "icon0")
//        } else {
//            iconView.frame = CGRectMake(20, 5, 40, 40)
//            nameLabel.frame = CGRectMake(70, 5, self.width - 70, 15)
//            nameLabel.textAlignment = .left
//            constainerView.frame = CGRectMake(70, 25, labelWidth + 10, self.height - 30)
//            constainerView.backgroundColor = .mainBlueColor
//            iconView.image = UIImage(named: "icon1")
//        }
//
//        messageLabel.frame = CGRectMake(5, 10, labelWidth, constainerView.height - 20)
        if currentUserID == message?.from {
            iconView.frame = CGRect.init(x: self.width - 60, y: 5, width: 40, height: 40)
            nameLabel.frame = CGRect.init(x: 0, y: 5, width: self.width - 70, height: 15)
            nameLabel.textAlignment = .right
            constainerView.frame = CGRect.init(x: self.width - labelWidth - 10 - 70, y: 25, width: labelWidth + 10, height: self.height - 30)
            let color = UIColor.init(red: 27 / 255.0, green: 188 / 255.0, blue: 155 / 255.0, alpha: 1)
            constainerView.backgroundColor = .mainBlueColor
            iconView.image = UIImage(named: "icon0")
        } else {
            iconView.frame = CGRect.init(x: 20, y: 5, width: 40, height: 40)
            nameLabel.frame = CGRect.init(x: 70, y: 5, width: self.width - 70, height: 15)
            nameLabel.textAlignment = .left
            constainerView.frame = CGRect.init(x: 70, y: 25, width: labelWidth + 10, height: self.height - 30)
            constainerView.backgroundColor = .mainBlueColor
            iconView.image = UIImage(named: "icon1")
        }
        messageLabel.frame = CGRect.init(x: 5, y: 10, width: labelWidth, height: constainerView.height - 20)

        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        selectionStyle = .none
        self.backgroundColor = .clear
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(constainerView)
        constainerView.addSubview(messageLabel)

    }
    
}
