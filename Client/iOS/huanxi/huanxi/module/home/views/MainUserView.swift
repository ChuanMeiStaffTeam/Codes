//
//  MainUserView.swift
//  huanxi
//
//  Created by jack on 2024/2/28.
//

import UIKit
import SnapKit

class MainUserView: UIView {
    
    let names: [String] = ["你的快拍", "zixuanooo", "diza", "dnsk", "jack", "rose"]
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize.init(width: 100, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension MainUserView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.label.text = names[indexPath.row]
        let nameStr = "avatar_test_" + String(indexPath.row)
        cell.imageView.image = UIImage.init(named: nameStr)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HUDHelper.showToast("点击了用户")
        
        guard let image = UIImage.init(named: "list_7") else { return }
        // 上传单张图片
//        NetworkManager.shared.uploadSingleImage(path: "userinfo/updateAvatar", parameters: ["":""], image: image) { model in
//
//        } failure: { error in
//
//        }

        // 上传多张图片
//        NetworkManager.shared.uploadMultipleImages(path: "postImage/article", parameters: ["":""], images: [image, image, image]) { model in
//            
//        } failure: { error in
//
//        }

        
    }
}

class CustomCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.init(named: "main_snapshot")
        imageView.layer.cornerRadius = 32.5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "用户名"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(5)
            make.width.height.equalTo(65)
        }
        
        label.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-5)
            make.centerX.equalToSuperview().offset(0)
            make.height.equalTo(12)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


/*这段代码主要实现了一个展示用户列表的视图。

具体来说，它做了以下几件事：

定义了一个自定义视图: MainUserView 继承自 UIView，是一个自定义的视图类。
创建了一个集合视图: collectionView 是一个水平滚动的 UICollectionView，用来展示用户列表。
自定义集合视图单元格: CustomCollectionViewCell 是一个自定义的集合视图单元格，用于展示单个用户的信息，包括头像和用户名。
设置数据源和代理: MainUserView 实现了 UICollectionViewDataSource 和 UICollectionViewDelegate 协议，负责提供数据源和处理用户交互。
布局视图: 使用 SnapKit 来设置 collectionView 的约束，使其占据视图的大部分区域。
配置单元格: 在 cellForItemAt 方法中，为每个单元格设置对应的头像和用户名。
处理用户点击: 在 didSelectItemAt 方法中，当用户点击某个单元格时，会触发一个事件（目前是显示一个提示信息），并包含了一些注释掉的代码，可能用于后续的上传图片功能。
代码的重点和细节：

SnapKit: 使用 SnapKit 来布局视图，使得布局更加灵活和可维护。
自定义单元格: 通过自定义 CustomCollectionViewCell 来控制每个单元格的样式和内容。
数据源和代理: MainUserView 同时充当了 UICollectionView 的数据源和代理，负责提供数据和处理用户交互。
图片加载: 代码中使用了 UIImage.init(named:) 来加载本地图片，但在实际应用中，可能会从网络加载图片。
上传图片: 注释掉的代码部分显示了上传图片的意图，但具体的实现细节未给出。
代码的局限性：

数据来源: 当前的用户名数据是硬编码在 names 数组中的，在实际应用中，通常会从网络接口获取用户信息。
图片加载: 对于大量的图片，使用 UIImage.init(named:) 加载本地图片可能会影响性能，可以考虑使用异步加载图片的框架。
用户交互: 目前点击用户单元格后，只显示了一个提示信息，没有实现更具体的交互逻辑。
总结

 这段代码实现了一个简单的用户列表视图，展示了如何使用 UICollectionView 来展示一系列数据，以及如何自定义单元格的样式。它可以作为学习 iOS 开发的一个基础示例。*/
