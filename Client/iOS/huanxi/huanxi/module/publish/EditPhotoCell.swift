//
//  EditPhotoCell.swift
//  huanxi
//
//  Created by jack on 2024/3/6.
//

import UIKit

class EditPhotoCell: UICollectionViewCell {
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    let filterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(imgView)
        contentView.addSubview(filterLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        filterLabel.frame = CGRect(x: 0, y: 0, width: width, height: 25)
        imgView.frame = CGRect(x: 3, y: 27, width: 94, height: 94)
        
    }
    
}
