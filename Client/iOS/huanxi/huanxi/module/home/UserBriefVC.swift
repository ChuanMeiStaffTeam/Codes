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
    
/*功能

这段代码实现了一个简的用户概况视图控制器，用于展示用户的基本信息。

内容解析

类定义: UserBriefVC 是一个继承自 BaseViewController 的视图控制器类，用于展示用户概况。
属性:
user: 一个可选的 UserInfoModel 类型属性，用来存储用户信息数据。
avatar: 用户头像的 UIImageView 实例。
useeNameLabel: 用户名称的 UILabel 实例。
lastLoginTimeLabel: 用户上次登录时间的 UILabel 实例。
方法:
viewDidLoad: 视图加载完成时调用的方法，负责初始化视图和数据。
setupUI: 设置用户界面的方法，主要负责头像、用户名、上次登录时间标签的创建、配置和布局。
代码详解

用户属性设置:

类中定义了一个可选的 UserInfoModel 类型的属性 user，用来存储要展示的用户信息数据。在使用这个视图控制器之前，需要为该属性赋值。
用户界面搭建:

setupUI 方法负责搭建用户界面的 UI 元素。
首先，根据 user.profilePictureUrl 属性的值，使用 Kingfisher 加载用户头像。如果头像地址以 "http" 开头，则认为是网络地址，使用 Kingfisher 加载网络图片；否则，认为是本地图片名称，直接设置图片。
然后，分别为用户名和上次登录时间设置文本内容。
最后，使用 UIStackView 将头像、用户名、登录时间这三个元素垂直排列，并设置其样式和约束。
可改进之处

错误处理: 目前代码没有处理网络加载头像失败的情况。可以添加错误处理，例如加载失败时使用默认头像。
数据来源: 代码没有明确指定如何获取用户信息数据 user。可以考虑在外部为该属性赋值，或者通过网络请求获取用户信息。
可扩展性: 目前只展示了用户的头像、用户名和上次登录时间，可以根据需要扩展展示更多的用户信息，例如个性签名、关注人数、粉丝人数等。
总结

这段代码实现了一个基本的用户概况视图控制器，可以用于在应用的不同位置展示用户的基本信息。通过改进错误处理、数据来源和可扩展性，可以使其更加健壮和灵活。*/
