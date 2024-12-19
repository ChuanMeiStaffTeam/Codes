//
//  SearchSugUserCell.swift
//  huanxi
//
//  Created by rslz on 2024/12/19.
//

import UIKit

class SearchSugUserCell: UITableViewCell {
    
    let iconImgView = UIImageView()
    let nameLabel = UILabel()
    let contentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        iconImgView.layer.cornerRadius = 24
        iconImgView.layer.masksToBounds = true
        contentView.addSubview(iconImgView)
        iconImgView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalToSuperview().offset(12)
            make.height.width.equalTo(48)
        }
        
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 14)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImgView.snp.top).offset(5)
            make.left.equalTo(iconImgView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-36)
            make.height.equalTo(20)
        }
        
        contentLabel.textColor = .init(hexString: "#777777")
        contentLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.bottom.equalTo(iconImgView.snp.bottom).offset(-5)
            make.left.equalTo(iconImgView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-36)
            make.height.equalTo(20)
        }
        
    }
    
    var user: UserInfoModel? {
        didSet {
            if let urlStr = user?.profilePictureUrl {
                if urlStr.contains("http") {
                    iconImgView.kf.setImage(with: URL.init(string: urlStr))
                } else {
                    iconImgView.image = UIImage.init(named: urlStr)
                }
            }
            nameLabel.text = user?.username ?? "游客"
            contentLabel.text = user?.bio
        }
    }
    
}
