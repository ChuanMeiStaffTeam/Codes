//
//  WaterfallCollectionViewCell.swift
//  huanxi
//
//  Created by jack on 2024/6/22.
//

import UIKit

class WaterfallCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "WaterfallCollectionViewCell"
    
    let imgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(imgView)
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    
    var model: PostModel? {
        didSet {
            if let urlStr = model?.images?.first?.imageUrl {
                if urlStr.contains("http") {
                    imgView.kf.setImage(with: URL.init(string: urlStr))
                } else {
                    imgView.image = UIImage.init(named: urlStr)
                }
            }
        }
    }
}
