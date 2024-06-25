//
//  ContentTableViewCell.swift
//  huanxi
//
//  Created by jack on 2024/6/23.
//

import UIKit
import SnapKit

class ContentTableViewCell: UITableViewCell {
    static let identifier = "ContentTableViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .black
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 56, height: 56))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.top.equalTo(iconImageView.snp.top).offset(8)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.bottom.equalTo(iconImageView.snp.bottom).offset(-8)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        titleLabel.text = text
        iconImageView.image = UIImage(named: "sample") // 假设有个名为 "sample" 的占位图片
    }
    
    func reloadData(indexPath: IndexPath) {
        
        let index = indexPath.row
        let names = ["zixuanooo", "diza", "dnsk", "jack", "rose", "zixuanooo", "diza", "dnsk", "jack", "rose"]
        let icons = ["icon0", "icon1", "icon2", "icon3", "icon4", "icon5", "icon0", "icon1", "icon2", "icon3"]
        let contents = ["电话就是不丢吃不都吃不饿还问", "元旦快乐哈哈哈哈哈😄", "评论123哈说的话说的", "i为u你是看见当年参加考试", "建军节说的那就是承诺", "几句话素材你说你刺猬", "u你说的没时间", "OK从事记单词哦接送", "的产业化丢吃呢", "ID农村建设的奶茶"]

        
        iconImageView.image = UIImage.init(named: icons[index])
        titleLabel.text = names[index]
        contentLabel.text = contents[index]
        
    }
}
