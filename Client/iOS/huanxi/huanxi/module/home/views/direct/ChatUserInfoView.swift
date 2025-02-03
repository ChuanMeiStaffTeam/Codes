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


/*代码功能

这段代码定义了一个名为 ChatUserInfoView 的自定义视图，主要用于在聊天应用中展示用户信息。这个视图可以用来显示用户的头像、昵称、粉丝数、帖子数、个人简介等信息。

代码结构

类定义: ChatUserInfoView 继承自 UIView，是一个自定义的视图类。
属性:
iconImgView: 一个 UIImageView，用于显示用户的头像。
nameLabel: 一个 UILabel，用于显示用户的昵称。
fansLabel: 一个 UILabel，用于显示用户的粉丝数。
postsLabel: 一个 UILabel，用于显示用户的帖子数。
descriptionLabel: 一个 UILabel，用于显示用户的个人简介。
lookBtn: 一个 UIButton，用于跳转到用户的个人主页（按钮上的文字为“查看主页”）。
方法:
init(coder:): 这个初始化方法通常用于从 Interface Builder 中加载视图，这里标记为未实现。
init(frame:): 这个初始化方法用于在代码中创建视图实例，设置视图的初始大小和位置。
setupData(): 这个方法用于设置视图中显示的初始数据，例如头像、昵称等。
setupView(): 这个方法用于设置视图的布局，使用 SnapKit 这个第三方库来定义各个子视图的约束，从而实现自适应布局。
lookBtnClick(): 这个方法应该是按钮的点击事件处理函数，但目前没有具体的实现。
代码逻辑

创建视图: 当创建 ChatUserInfoView 实例时，会调用 init(frame:) 方法，进而调用 setupView 和 setupData 方法。
设置布局: setupView 方法使用 SnapKit 定义各个子视图之间的约束关系，从而实现视图的布局。
设置数据: setupData 方法设置视图中显示的初始数据，例如头像、昵称等。
按钮点击事件: 当用户点击 "查看主页" 按钮时，会触发 lookBtnClick 方法，但目前这个方法没有具体的实现。
代码优点

结构清晰: 代码结构清晰，易于理解。
使用 SnapKit: 使用 SnapKit 来定义约束，使得布局更加灵活和可维护。
可复用性: 这个自定义视图可以复用在不同的聊天界面中。
改进建议

完善按钮点击事件: 实现 lookBtnClick 方法，当用户点击按钮时，跳转到相应的用户主页。
数据绑定: 可以考虑使用数据绑定来动态更新视图中的数据，例如当用户信息发生变化时，自动更新视图。
国际化: 如果需要支持多语言，可以将字符串提取出来，使用本地化方式进行处理。
性能优化: 如果需要展示大量用户信息，可以考虑一些性能优化措施，例如复用单元格、延迟加载图片等。
总结

 这段代码实现了一个简单的用户信息视图，可以用于聊天应用中展示用户信息。通过自定义视图，可以提高代码的可复用性和可维护性。*/
