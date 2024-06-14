//
//  ChatUserInfoView.swift
//  huanxi
//
//  Created by Jack on 2024/6/4.
//

import UIKit

class ChatUserInfoView: UIView {
    
    let iconImgView = UIImageView()
    let nameLabel = UILabel()
    let fansLabel = UILabel()
    let postsLabel = UILabel()
    let descriptionLabel = UILabel()
    let lookBtn = UIButton()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupData()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.height = lookBtn.bottom + 10
//    }
    
    func setupData() {
        iconImgView.image = UIImage(named: "icon0")
        nameLabel.text = "yao.D.C"
        fansLabel.text = "8位粉丝"
        postsLabel.text = "34篇帖子"
        descriptionLabel.text = "你自2018年已关注过这个Instagr"
        
    }
    
    @objc func lookBtnClick() {
        
    }
    
    func setupView() {
        
        iconImgView.layer.cornerRadius = 40
        iconImgView.layer.masksToBounds = true
        addSubview(iconImgView)
        iconImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.height.width.equalTo(80)
            make.top.equalToSuperview().offset(16)
        }
        
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.top.equalTo(iconImgView.snp.bottom).offset(16)
            make.height.equalTo(20)
        }
        
        let instagramLabel = UILabel()
        instagramLabel.textColor = .white
        instagramLabel.text = "instagram"
        instagramLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        addSubview(instagramLabel)
        instagramLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.height.equalTo(20)
        }
        
        let grayColor = UIColor.init(hex: 0x656565)
        
        let pointView = UIView()
        pointView.backgroundColor = grayColor
        pointView.layer.cornerRadius = 1
        pointView.layer.masksToBounds = true
        addSubview(pointView)
        pointView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.top.equalTo(instagramLabel.snp.bottom).offset(26)
            make.width.height.equalTo(2)
        }
        
        fansLabel.textColor = grayColor
        fansLabel.font = .systemFont(ofSize: 14, weight: .regular)
        addSubview(fansLabel)
        fansLabel.snp.makeConstraints { make in
            make.right.equalTo(pointView.snp.left).offset(-10)
            make.centerY.equalTo(pointView).offset(0)
            make.height.equalTo(20)
        }
        
        postsLabel.textColor = grayColor
        postsLabel.font = .systemFont(ofSize: 14, weight: .regular)
        addSubview(postsLabel)
        postsLabel.snp.makeConstraints { make in
            make.left.equalTo(pointView.snp.right).offset(10)
            make.centerY.equalTo(pointView).offset(0)
            make.height.equalTo(20)
        }
        
        descriptionLabel.textColor = grayColor
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.top.equalTo(postsLabel.snp.bottom).offset(12)
            make.height.equalTo(20)
        }
        
        lookBtn.backgroundColor = .clear
        lookBtn.layer.cornerRadius = 4
        lookBtn.layer.masksToBounds = true
        lookBtn.setTitle("查看主页", for: .normal)
        lookBtn.layer.borderColor = UIColor.init(hex: 0x797979).cgColor
        lookBtn.layer.borderWidth = 1.0
        lookBtn.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        lookBtn.addTarget(self, action: #selector(lookBtnClick), for: .touchUpInside)
        addSubview(lookBtn)
        lookBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.width.equalTo(76)
            make.height.equalTo(26)
            make.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
}
