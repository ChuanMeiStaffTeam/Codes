//
//  UpdatesThisMonthCell.swift
//  huanxi
//
//  Created by jack on 2024/3/28.
//

import UIKit

class UpdatesThisMonthCell: UITableViewCell {
    
    var followBlock: (()->Void)?
    
    let icon = UIImageView()
    let contentLabel = UILabel()
    let timeLabel = UILabel()
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
        icon.image = UIImage.init(named: "main_recommend_text")
        contentLabel.text = "jeffreywongvb开始关注你了哦"
        timeLabel.text = "4周"
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
            make.centerY.equalToSuperview().offset(0)
        }
        
        contentLabel.textColor = .white
        contentLabel.font = .boldSystemFont(ofSize: 14)
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.top).offset(0)
            make.left.equalTo(icon.snp.right).offset(16);
        }
        
        timeLabel.textColor = .init(hexString: "#777777")
        timeLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(icon.snp.bottom).offset(0)
            make.left.equalTo(icon.snp.right).offset(16);
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
            make.right.equalToSuperview().offset(-16)
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
    
}
