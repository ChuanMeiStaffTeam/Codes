//
//  EditPhotosView.swift
//  huanxi
//
//  Created by jack on 2024/3/24.
//

import UIKit

class EditPhotosView: UIView {
    
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
    
}
