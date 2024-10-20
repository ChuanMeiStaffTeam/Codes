//
//  EditPhotosView.swift
//  huanxi
//
//  Created by jack on 2024/3/24.
//

import UIKit
import SwiftUI

class EditPhotosView: UIView {
    
    var didSelectedItemBlock: ((Int) ->Void)?
    var currentIndex = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var images: [UIImage] = [] {
        didSet {
            if images.count == 1 {
                collectionView.isHidden = true
                imgView.isHidden = false
                let image = images.first
                imgView.image = image
            } else {
                collectionView.isHidden = false
                imgView.isHidden = true
                collectionView.reloadData()
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        addSubview(collectionView)
        addSubview(imgView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let cellIdentifier = "imageCell"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        let width = .screenWidth - 32 - 40
        layout.itemSize = CGSize(width: width, height: width)
        
        let collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: CGFloat.screenWidth, height: .screenWidth - 32), collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(EditPhotosCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        return collectionView
    }()
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        let width = .screenWidth - 32
        imageView.frame = CGRect.init(x: 16, y: 0, width: width, height: width)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.mainBlueColor.cgColor
        imageView.layer.borderWidth = 2.0
        return imageView
    }()
}

extension EditPhotosView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! EditPhotosCell
        let image = images[indexPath.row]
        cell.imgView.image = image
        
        cell.showBorder(hidden: !(currentIndex==indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let block = didSelectedItemBlock {
            block(indexPath.row)
        }
        
        
        if indexPath.row == images.count - 1 {
            let offsetX = collectionView.contentSize.width
            collectionView.setContentOffset(CGPoint.init(x: offsetX-CGFloat.screenWidth, y: 9), animated: true)
        } else {
            if indexPath.row == 0 {
                collectionView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            } else {
                let width = .screenWidth - 32 - 40
                let offsetX = (width + 16) + (CGFloat(indexPath.row) - 1) * (width + 10)
                collectionView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return edgeInsets
    }
}


class EditPhotosCell: UICollectionViewCell {
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
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
        
        imgView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        
    }
    
    func showBorder(hidden: Bool) {
        if hidden {
            imgView.layer.borderColor = UIColor.clear.cgColor
            imgView.layer.borderWidth = 0.0
        } else {
            imgView.layer.borderColor = UIColor.mainBlueColor.cgColor
            imgView.layer.borderWidth = 2.0
        }
        
    }
    
}
