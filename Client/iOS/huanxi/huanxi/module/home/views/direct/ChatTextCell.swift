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

/*代码功能

这段代码定义了一个名为 ChatTextCell 的自定义 UITableViewCell 类，主要用于在聊天应用中展示文本类型的聊天消息。它负责展示聊天消息的发送者头像、昵称和文本内容。

代码结构

属性:
iconView: 一个 UIImageView，用于显示发送消息用户的头像。
nameLabel: 一个 UILabel，用于显示发送消息用户的昵称。
constainerView: 一个 UIView，作为消息文本的容器，设置了圆角和背景色。
messageLabel: 一个 UILabel，用于显示聊天消息的文本内容。
message: 一个 NIMMessage? 类型的可选属性，用于存储当前显示的消息。当这个属性被赋值时，会触发 didSet 方法，更新单元格的内容。
labelWidth: 一个 CGFloat 类型的属性，用于存储消息文本标签的宽度。
方法:
init(style:reuseIdentifier:): 初始化方法，设置单元格的基本样式，并调用 setupView() 方法进行布局。
setupView(): 这个方法将各个子视图添加到 contentView 中，并进行基本的布局。
layoutSubviews(): 这个方法在单元格的布局发生变化时被调用。它根据消息的发送者（当前用户或其他用户）来调整子视图的位置和样式。具体来说，它会根据发送者来设置头像、昵称、消息容器的位置和背景色。
代码逻辑

创建单元格: 当需要展示一条聊天消息时，会创建一个 ChatTextCell 实例。
设置数据: 调用 message 属性的 setter 方法，将聊天消息的数据传递给单元格。
更新界面: didSet 方法会根据新的消息数据，更新头像、昵称和消息文本的内容。
布局子视图: layoutSubviews 方法会根据消息的发送者，调整子视图的位置和样式，以区分当前用户发送的消息和接收到的消息。
代码亮点

自定义: 通过自定义 UITableViewCell，可以灵活地控制聊天消息的显示样式。
数据驱动: 使用 message 属性来驱动单元格的更新，使得代码结构更加清晰。
布局灵活: 通过 layoutSubviews 方法，可以根据不同的情况调整布局。
第三方库: 使用 Kingfisher 库来加载头像图片。
NIMSDK: 使用 NIMSDK 来获取用户信息。
潜在改进

约束布局: 可以考虑使用 Auto Layout 或第三方约束布局库，来简化布局的定义。
性能优化: 如果需要展示大量聊天消息，可以考虑使用 Cell Reuse 机制来提高性能。
可访问性: 可以添加一些可访问性特性，比如为图片添加描述文本，或者为文本设置合适的字体大小和颜色。
总结

 这段代码实现了一个功能相对完整的聊天消息单元格，可以满足基本的聊天界面需求。通过进一步的定制和优化，可以打造出更加丰富多彩的聊天界面。*/
