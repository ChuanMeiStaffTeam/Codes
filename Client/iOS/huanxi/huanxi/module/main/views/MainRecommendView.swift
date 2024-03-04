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
        return 10 // 设置 cell 数量
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
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
        label.font = .systemFont(ofSize: 14)
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
        button.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
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
        
        reloadData()
    }
    
    func reloadData() {
        
        nameLabel.text = "jack"
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
