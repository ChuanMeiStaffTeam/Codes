//
//  MineHeaderView.swift
//  huanxi
//
//  Created by Jack on 2024/5/20.
//

import UIKit

class MineHeaderView: UIView {
    
    let iconImgView = UIImageView()
    let postsItemView = MineHeaderItemView()
    let fansItemView = MineHeaderItemView()
    let followedItemView = MineHeaderItemView()
    let editButton = UIButton(type: .custom)
    
    var editHomePageBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        
        iconImgView.image = UIImage(named: "main_recommend_text")
        self.addSubview(iconImgView)
        iconImgView.layer.cornerRadius = 40
        iconImgView.layer.masksToBounds = true
        iconImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.width.height.equalTo(80)
        }
        
        followedItemView.titleLabel.text = "已关注"
        followedItemView.valueLabel.text = "123"
        self.addSubview(followedItemView)
        followedItemView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-32)
            make.centerY.equalTo(iconImgView).offset(0)
            make.width.equalTo(60)
        }
        
        fansItemView.titleLabel.text = "粉丝"
        fansItemView.valueLabel.text = "12345"
        self.addSubview(fansItemView)
        fansItemView.snp.makeConstraints { make in
            make.right.equalTo(followedItemView.snp.left).offset(-32)
            make.centerY.equalTo(iconImgView).offset(0)
            make.width.equalTo(60)
        }
        
        postsItemView.titleLabel.text = "帖子"
        postsItemView.valueLabel.text = "12"
        self.addSubview(postsItemView)
        postsItemView.snp.makeConstraints { make in
            make.right.equalTo(fansItemView.snp.left).offset(-32)
            make.centerY.equalTo(iconImgView).offset(0)
            make.width.equalTo(60)
        }
        
        editButton.setTitle("编辑主页", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        editButton.addTarget(self, action: #selector(editUserAction), for: .touchUpInside)
        editButton.layer.cornerRadius = 6
        editButton.layer.masksToBounds = true
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.white.cgColor
        self.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(42)
            make.bottom.equalToSuperview().offset(-5)
        }
        
    }
    
    
    @objc func editUserAction() {
        if let block = editHomePageBlock {
            block()
        }
    }
    
}


class MineHeaderItemView: UIView {
    
    let valueLabel = UILabel()
    let titleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        valueLabel.textColor = .white
        valueLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.addSubview(valueLabel)
        
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.addSubview(titleLabel)
        
        valueLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.centerY.equalToSuperview().offset(-10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.centerY.equalToSuperview().offset(10)
        }
    }
    
}
