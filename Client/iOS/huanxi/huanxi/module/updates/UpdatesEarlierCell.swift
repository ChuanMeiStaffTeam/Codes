//
//  UpdatesEarlierCell.swift
//  huanxi
//
//  Created by jack on 2024/3/28.
//

import UIKit

class UpdatesEarlierCell: UITableViewCell {
        
    let icon = UIImageView()
    let contentLabel = UILabel()
    let timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        icon.image = UIImage.init(named: "main_pic_test")
        contentLabel.text = "关注 Hannah,hong_longjie 和其他用户，查看他们的照片和视频"
        timeLabel.text = "5周"
    }
    
    func setupView() {
        selectionStyle = .none
        self.backgroundColor = .clear

        icon.layer.cornerRadius = 20
        icon.layer.masksToBounds = true
        contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview().offset(0)
        }
        
        contentLabel.textColor = .white
        contentLabel.font = .boldSystemFont(ofSize: 14)
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.top).offset(0)
            make.left.equalTo(icon.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        timeLabel.textColor = .init(hexString: "#777777")
        timeLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(icon.snp.bottom).offset(0)
            make.left.equalTo(icon.snp.right).offset(16)
        }
        
    }
    
}
