//
//  DirectChatCell.swift
//  huanxi
//
//  Created by Jack on 2024/6/4.
//

import UIKit

class DirectChatCell: UITableViewCell {
    
    let iconImgView = UIImageView()
    let nameLabel = UILabel()
    let contentLabel = UILabel()
    let cameraImgView = UIImageView(image: UIImage(named: "direct_camera"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(_ model: ChatModel) {
        
        iconImgView.image = UIImage(named: model.icon)
        nameLabel.text = model.name
        contentLabel.text = model.content
        
    }
    
    func setupView() {
        selectionStyle = .none
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(iconImgView)
        iconImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(48)
        }
        
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 14)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImgView.snp.top).offset(2)
            make.left.equalTo(iconImgView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-36)
            make.height.equalTo(20)
        }
        
        contentLabel.textColor = .init(hexString: "#777777")
        contentLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.bottom.equalTo(iconImgView.snp.bottom).offset(-2)
            make.left.equalTo(iconImgView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-36)
            make.height.equalTo(20)
        }
        
        contentView.addSubview(cameraImgView)
        cameraImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(-16)
            make.height.width.equalTo(16)
            make.width.equalTo(16)
        }
    }
    
    
}

/*代码功能

这段代码定义了一个名为 DirectChatCell 的类，它是 iOS 应用程序中用来展示聊天消息的自定义 UITableViewCell 子类。它主要用于聊天界面中，展示一条聊天消息的内容。

代码结构

属性:
iconImgView: 一个 UIImageView，用来显示发送消息用户的头像。
nameLabel: 一个 UILabel，用来显示发送消息用户的名称。
contentLabel: 一个 UILabel，用来显示聊天消息的内容。
cameraImgView: 一个 UIImageView，用来显示一个相机图标，可能表示消息中包含图片或视频附件。
方法:
init(style:reuseIdentifier:): 初始化方法，设置单元格的样式，并调用 setupView 方法进行布局。
reloadData(_:): 这个方法接收一个 ChatModel 对象作为参数，用于更新单元格的内容。根据 ChatModel 中的数据，设置头像、用户名和消息内容。
setupView(): 这个方法负责设置单元格子视图的布局，使用 SnapKit 来定义约束，确定各个子视图的位置和大小。
代码逻辑

创建单元格: 当需要展示一条聊天消息时，会创建一个 DirectChatCell 实例。
设置数据: 调用 reloadData(_:) 方法，将聊天消息的数据传递给单元格，更新单元格的显示内容。
显示单元格: 将创建好的单元格添加到 UITableView 中，展示在界面上。
代码作用

自定义聊天界面: 通过自定义 UITableViewCell，可以灵活地控制聊天消息的显示样式。
展示聊天内容: 清晰地展示聊天消息的发送者、内容和附件信息。
提高用户体验: 提供一个美观、易于阅读的聊天界面。
总结

这段代码实现了一个简单的聊天消息单元格，为构建聊天应用提供了一个基础组件。通过自定义 ChatModel 和调整样式，可以实现更加丰富多彩的聊天界面。*/


