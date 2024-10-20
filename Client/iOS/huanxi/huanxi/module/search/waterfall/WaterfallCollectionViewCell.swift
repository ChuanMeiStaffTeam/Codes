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
        
        contentView.addSubview(imgView)
        imgView.frame = CGRect.init(x: 2, y: 2, width: width - 4, height: height - 4)
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
        contentView.backgroundColor = .black
    }
    
    func configure(with image: String) {
        imgView.image = UIImage.init(named: image)
    }
}
