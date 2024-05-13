//
//  UpdatesRecommendCell.swift
//  huanxi
//
//  Created by jack on 2024/3/28.
//

import UIKit

class UpdatesRecommendCell: UITableViewCell {
    
    var followBlock: (()->Void)?
    var closeBlock: (()->Void)?
    
    let icon = UIImageView()
    let nameLabel = UILabel()
    let contentLabel = UILabel()
    let tagLabel = UILabel()
    let followBtn = UIButton(type: .custom)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        icon.image = UIImage.init(named: "touxiang_test")
        nameLabel.text = "jack"
        contentLabel.text = "jeffreywongvb开始关注你了哦"
        tagLabel.text = "热门"
        followBtn.setTitle("已关注", for: .normal)
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
            make.top.equalToSuperview().offset(16)
        }
        
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 14)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.top).offset(0)
            make.left.equalTo(icon.snp.right).offset(16);
        }
        
        contentLabel.textColor = .white
        contentLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.bottom.equalTo(icon.snp.bottom).offset(0)
            make.left.equalTo(icon.snp.right).offset(16);
        }
        
        tagLabel.textColor = .init(hexString: "#777777")
        tagLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.left.equalTo(icon.snp.right).offset(16);
        }
        
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.setImage(UIImage.init(named: "publish_close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        contentView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(0)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        followBtn.setTitleColor(.white, for: .normal)
        followBtn.titleLabel?.font = .systemFont(ofSize: 14)
        followBtn.layer.cornerRadius = 4
        followBtn.layer.masksToBounds = true
        followBtn.layer.borderWidth = 1
        followBtn.addTarget(self, action: #selector(followAction), for: .touchUpInside)
        followBtn.layer.borderColor = UIColor.init(hexString: "#333333").cgColor
        contentView.addSubview(followBtn)
        followBtn.snp.makeConstraints { make in
            make.right.equalTo(closeBtn.snp.left).offset(-16)
            make.centerY.equalToSuperview().offset(0)
            make.height.equalTo(28)
            make.width.equalTo(followBtn.intrinsicContentSize.width+30)
        }
    }
    
    @objc func followAction() {
        if let block = followBlock {
            block()
        }
    }
    
    @objc func closeAction() {
        if let block = closeBlock {
            block()
        }
    }
}
