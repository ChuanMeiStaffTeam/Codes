//
//  PhotoAlbumView.swift
//  huanxi
//
//  Created by jack on 2024/3/2.
//

import UIKit
import Photos

protocol PhotoAlbumViewDelegate: AnyObject {
    func didSelectImage(at index: Int, isSelected: Bool)
}

class PhotoAlbumView: UIView {
    
    var images: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    weak var delegate: PhotoAlbumViewDelegate?
    
    private var isMultiSelectEnabled: Bool = false
    
    private let cellIdentifier = "PhotoCell"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        let cellWidth = (UIScreen.main.bounds.width - 3) / 4
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleMultiSelect(enabled: Bool) {
        isMultiSelectEnabled = enabled
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
}

extension PhotoAlbumView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PhotoCell
        let image = images[indexPath.item]
        cell.indexPath = indexPath
        cell.imgView.image = image
        cell.isMultiSelectEnabled = isMultiSelectEnabled
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard isMultiSelectEnabled else { return }
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            cell.toggleSelection()
        }
    }
}

extension PhotoAlbumView: PhotoCellDelegate {
    
    func didSelectImage(at index: Int, isSelected: Bool) {
        delegate?.didSelectImage(at: index, isSelected: isSelected)
    }
}

protocol PhotoCellDelegate: AnyObject {
    func didSelectImage(at index: Int, isSelected: Bool)
}

class PhotoCell: UICollectionViewCell {
    
    var isMultiSelectEnabled: Bool = false {
        didSet {
            selectionView.isHidden = !isMultiSelectEnabled
        }
    }
    
    var indexPath: IndexPath?
    
    weak var delegate: PhotoCellDelegate?
    
    private var _isSelected: Bool = false
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let selectionView: UIImageView = {
        let selectionView = UIImageView()
        return selectionView
    }()
    
    private let selectionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = .init(hexString: "#009DFF")
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(imgView)
        contentView.addSubview(selectionLabel)
        contentView.addSubview(selectionView)
        
        selectionView.isHidden = true
        selectionView.image = UIImage(named: "publish_pic_unselectes")
        
        selectionLabel.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgView.frame = contentView.bounds
        selectionView.frame = CGRect(x: contentView.bounds.width - 22.5, y: 1.5, width: 21, height: 21)
        selectionLabel.frame = CGRect(x: contentView.bounds.width - 20, y: 4, width: 16, height: 16)
    }
    
    func toggleSelection() {
        _isSelected = !_isSelected
//        selectionView.image = _isSelected ? UIImage(named: "selected_icon") : UIImage(named: "unselected_icon")
        
        selectionLabel.isHidden = !_isSelected
//        selectionLabel.text = "\(String(describing: delegate?.didSelectImage(at: self.tag, isSelected: _isSelected)))"
    }
    
    @objc private func handleTap() {
        guard isMultiSelectEnabled else { return }
        toggleSelection()
        delegate?.didSelectImage(at: indexPath?.row ?? 0, isSelected: isSelected)
    }
}
