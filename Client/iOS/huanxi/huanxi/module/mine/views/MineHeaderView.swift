//
//  MineHeaderView.swift
//  huanxi
//
//  Created by Jack on 2024/5/20.
//

import UIKit

class MineHeaderView: UIView {
    
    var type: MineType
    
    private let vStackView = UIStackView().then({view in
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 20
    })
    
    private let infoStackView = UIStackView().then({view in
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 20
        view.distribution = .fill
    })
    
    private let iconImgView = UIImageView().then({view in
        view.image = UIImage(named: "main_recommend_text")
        view.layer.cornerRadius = 40
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
    })
    private let postsItemView = MineHeaderItemView().then({view in
        view.titleLabel.text = "帖子"
        view.valueLabel.text = "12"
    })
    private let fansItemView = MineHeaderItemView().then({view in
        view.titleLabel.text = "粉丝"
        view.valueLabel.text = "12345"
    })
    private let followedItemView = MineHeaderItemView().then({view in
        view.titleLabel.text = "已关注"
        view.valueLabel.text = "123"
    })
    lazy var editButton = UIButton().then({view in
        view.setTitle("编辑资料", for: .normal)
        let user = LoginManager.shared.getUserInfo()
        let noAvatar = user?.profilePictureUrl?.isEmpty ?? true
        let noName = user?.fullName?.isEmpty ?? true
        let noWeb = user?.websiteUrl?.isEmpty ?? true
        let noBio = user?.bio?.isEmpty ?? true
        let showHot = noAvatar || noName || noWeb || noBio
        view.setAttributedTitle(formatStatusText("编辑资料", showHot), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.addTarget(self, action: #selector(editUserAction), for: .touchUpInside)
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.isHidden = type != .mySelf
    })
    
    var editHomePageBlock: (()->Void)?
    

    
    init(type: MineType) {
        self.type = type
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        let space = UIView()
        
        [iconImgView, postsItemView, fansItemView, followedItemView, space].forEach{ infoStackView.addArrangedSubview($0) }

        iconImgView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        
        [postsItemView, fansItemView, followedItemView].forEach { itemView in
            itemView.snp.makeConstraints { make in
                make.width.equalTo(60)
            }
        }
        
        [infoStackView, editButton].forEach{ vStackView.addArrangedSubview($0) }
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.trailing.lessThanOrEqualToSuperview().inset(15)
            make.top.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().offset(5) // 确保底部间距
        }
        editButton.snp.makeConstraints { make in
            make.height.equalTo(37)
            make.width.equalTo(UIDevice.screenWidth - 30)
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
}

extension MineHeaderView {
    private func formatStatusText(_ text: String, _ isFirst: Bool = false) -> NSAttributedString {
        
        guard !text.isEmpty else {
            return NSMutableAttributedString(string: "")
        }
                
        let image = UIImage.ImageWithColor(UIColor.red, size: CGSize(width: 4, height: 4), cornerRadius: 2)
    
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
