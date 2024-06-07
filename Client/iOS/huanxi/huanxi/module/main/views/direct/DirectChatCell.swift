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
