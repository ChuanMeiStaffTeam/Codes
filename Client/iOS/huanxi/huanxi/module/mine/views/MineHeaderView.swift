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
        
        editButton.setTitle("编辑资料", for: .normal)
        let user = LoginManager.shared.getUserInfo()
        let noAvatar = user?.profilePictureUrl?.isEmpty ?? true
        let noName = user?.fullName?.isEmpty ?? true
        let noWeb = user?.websiteUrl?.isEmpty ?? true
        let noBio = user?.bio?.isEmpty ?? true
        let showHot = noAvatar || noName || noWeb || noBio
        editButton.setAttributedTitle(formatStatusText("编辑资料", showHot), for: .normal)
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
    
    func reloadData(_ user: UserInfoModel?) {
        if let urlStr = user?.profilePictureUrl {
            iconImgView.kf.setImage(with: URL.init(string: urlStr))
        }
        followedItemView.valueLabel.text = String(format: "%d", user?.followingCount ?? 0)
        postsItemView.valueLabel.text = String(format: "%d", user?.postCount ?? 0)
        fansItemView.valueLabel.text = String(format: "%d", user?.followerCount ?? 0)
    }
    
    @objc func editUserAction() {
        if let block = editHomePageBlock {
            block()
        }
    }
    
    private func formatStatusText(_ text: String, _ isFirst: Bool = false) -> NSAttributedString {
        
        guard !text.isEmpty else {
            return NSMutableAttributedString(string: "")
        }
        
        var color = UIColor.red
        
        let image = UIImage.ImageWithColor(color, size: CGSize(width: 4, height: 4), cornerRadius: 2)
    
        // 创建一个 NSTextAttachment 来包含图片
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(x: 0, y: 2, width: 4, height: 4) // 调整图片的大小和位置

        // 将 NSTextAttachment 转换为 NSAttributedString
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        // 创建一个可变的 NSAttributedString 来拼接文本和图片
        let attributedString = NSMutableAttributedString(string: "")
        
        // 添加图片
        attributedString.append(imageString)
        
        // 添加后半部分文字
        attributedString.append(NSAttributedString(string: " " + text))

        return attributedString
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
