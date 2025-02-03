//
//  MainRecommendView.swift
//  huanxi
//
//  Created by jack on 2024/2/28.
//


import UIKit
import SnapKit

class MainRecommendView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let cellWidth: CGFloat = 210
    private let cellHeight: CGFloat = 275
    private let cellSpacing: CGFloat = 10
    
    let names: [String] = ["zixuanooo", "diza", "dnsk", "jack", "rose", "zixuanooo", "diza", "dnsk", "jack", "rose"]

    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .init(hexString: "#121212")
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "CustomCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
//        collectionView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//            make.height.equalTo(cellHeight)
//        }
        collectionView.frame = CGRect.init(x: 0, y: 0, width: self.width, height: self.height)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count // 设置 cell 数量
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let imageStr = "avatar_test_" + String((indexPath.row % 4 + 1))
        cell.reloadData(name: names[indexPath.row], imageStr: imageStr)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15) // 设置左右间距为20（示例值）
        return edgeInsets
    }
    
}

class CustomCell: UICollectionViewCell {
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "main_recommend_text")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .init(hexString: "#7F7F7F")
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .init(hexString: "#0098FD")
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.setTitle("关注", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
//        button.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(tagLabel)
        contentView.addSubview(followButton)
        
        avatarImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(18)
            make.height.width.equalTo(148)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(10)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        followButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(180)
            make.height.equalTo(30)
        }
        
//        reloadData()
    }
    
    func reloadData(name: String, imageStr: String) {
        
        avatarImageView.image = UIImage(named: imageStr)
        nameLabel.text = name
        tagLabel.text = "热门"
        followButton.setTitle("关注", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func followButtonTapped() {
        // 处理关注按钮点击事件
        HUDHelper.showToast("点击了关注")
    }
}


/*代码主要功能：

这段代码实现了一个展示用户推荐列表的视图。它使用 UICollectionView 来水平展示一列用户卡片，每个卡片包含用户的头像、用户名、标签和关注按钮。

代码结构：

MainRecommendView 类:

属性:
cellWidth, cellHeight, cellSpacing: 定义了每个卡片的尺寸和间距。
names: 一个字符串数组，用于存储用户名称。
collectionView: 一个 UICollectionView 实例，用于展示用户卡片。
方法:
init(frame:): 初始化方法，创建 collectionView 并设置其布局和数据源。
collectionView(_:numberOfItemsInSection:): 返回需要展示的卡片数量，根据 names 数组的长度。
collectionView(_:cellForItemAt:): 为每个卡片配置数据，包括头像、用户名和标签。
collectionView(_:layout:sizeForItemAt:): 设置每个卡片的尺寸。
collectionView(_:layout:insetForSectionAt:): 设置卡片之间的间距。
CustomCell 类:

属性:
avatarImageView: 显示用户头像的 UIImageView。
nameLabel: 显示用户名称的 UILabel。
tagLabel: 显示用户标签的 UILabel。
followButton: 关注按钮。
方法:
init(frame:): 初始化方法，设置子视图的布局。
reloadData(name:imageStr:): 用于更新单元格的数据，包括头像、用户名和标签。
followButtonTapped: 关注按钮的点击事件处理函数（目前为空）。
代码逻辑:

创建视图: 当创建 MainRecommendView 实例时，会初始化 collectionView 并设置其布局和数据源。
配置单元格: collectionView(_:cellForItemAt:) 方法会为每个单元格设置对应的数据，包括头像、用户名和标签。
处理用户交互: 当用户点击某个单元格时，会触发 collectionView(_:didSelectItemAt:) 方法，目前只是显示一个提示信息，后续可以添加关注、查看用户详情等功能。
代码亮点:

使用 UICollectionView 实现水平滚动列表: 非常适合展示一系列相似的内容。
自定义单元格: 通过 CustomCell 来定制每个单元格的外观和布局。
SnapKit: 使用 SnapKit 来设置约束，简化布局。
代码结构清晰: 代码结构清晰，易于维护。
潜在改进:

数据源: 当前用户名和头像数据是硬编码的，可以从网络接口获取动态数据。
关注功能: 实现 followButtonTapped 方法，处理关注用户的逻辑。
性能优化: 对于大量数据，可以考虑使用异步加载图片、复用单元格等优化手段。
可扩展性: 可以添加更多的用户信息展示，比如用户简介、粉丝数等。
总结

 这段代码实现了一个简单的用户推荐列表，展示了如何使用 UICollectionView 来创建水平滚动列表，以及如何自定义单元格。它可以作为基础，用于构建更复杂的推荐系统。*/
