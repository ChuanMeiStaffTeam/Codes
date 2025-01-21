//
//  SearchTagListCell.swift
//  huanxi
//
//  Created by rslz on 2024/12/21.
//

import UIKit

class SearchTagListCell: UICollectionViewCell {

    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.postBgColor
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(imgView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.frame = contentView.bounds
        self.setLayoutSkeletonLayer()
    }
    
    // 控制骨架屏动画显示或隐藏的变量
    var isSkeletonVisible: Bool = true {
        didSet {
            if isSkeletonVisible {
                // 启动骨架屏动画
                self.showSkeletonAnimation()
            } else {
                // 停止骨架屏动画
                self.closeSkeletonAnimation()
            }
        }
    }
    
}

// MARK: 骨架屏配置
extension SearchTagListCell {
    func setLayoutSkeletonLayer() {
        imgView.layoutSkeletonLayer()
    }
    
    func showSkeletonAnimation() {
        imgView.startSkeletonAnimation()
    }
    
    func closeSkeletonAnimation() {
        imgView.stopSkeletonAnimation()
    }
}
