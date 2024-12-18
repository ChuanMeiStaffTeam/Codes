//
//  UserBriefVC.swift
//  huanxi
//
//  Created by rslz on 2024/12/18.
//

import UIKit
import Kingfisher

class UserBriefVC: BaseViewController {
        
    var user: UserInfoModel?
    
    private let avatar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "main_pic_test")
        view.layer.cornerRadius = 40
        view.layer.masksToBounds = true
        return view
    }()
    
    private let useeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white_60
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let lastLoginTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white_60
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
        if let urlStr = user?.profilePictureUrl {
            if urlStr.contains("http") {
                avatar.kf.setImage(with: URL.init(string: urlStr))
            } else {
                avatar.image = UIImage.init(named: urlStr)
            }
        }
        useeNameLabel.text = user?.username ?? "游客"
        lastLoginTimeLabel.text = "上次登录：\(user?.lastLoginAt ?? "2024-11-12 16:02:02")"

        // 创建 UIStackView
        let stackView = UIStackView(arrangedSubviews: [avatar, useeNameLabel, lastLoginTimeLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 20
        
        // 添加 StackView 到视图
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(UIDevice.sy_navigationFullHeight + 70)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        avatar.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
    }
    
}
    
