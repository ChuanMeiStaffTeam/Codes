//
//  PhotoAlbumView.swift
//  huanxi
//
//  Created by jack on 2024/3/2.
//

import UIKit
import Photos

protocol PhotoAlbumViewDelegate: AnyObject {
    func didSelectImages(at indexs: [Int], isSelected: Bool)
}

class PhotoAlbumView: UIView {
    
    var images: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var selectedAlbumIndexs: [Int] = []
    var currentPhotoIndex = 0
    
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
        if !enabled {
            while selectedAlbumIndexs.count > 1 {
                selectedAlbumIndexs.removeFirst()
            }
        }
        isMultiSelectEnabled = enabled
        delegate?.didSelectImages(at: selectedAlbumIndexs, isSelected: true)
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
        cell._isSelected = currentPhotoIndex == indexPath.row
        if let index = selectedAlbumIndexs.firstIndex(of: indexPath.row) {
            cell.selectedIndex = index
        } else {
            cell.selectedIndex = -1
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var isSelected = false
        if isMultiSelectEnabled {
            if selectedAlbumIndexs.contains(indexPath.row) {
                if selectedAlbumIndexs.count == 1 {
                    currentPhotoIndex = selectedAlbumIndexs.last ?? 0
                    selectedAlbumIndexs.removeAll { $0 == indexPath.row }
                } else {
                    selectedAlbumIndexs.removeAll { $0 == indexPath.row }
                    currentPhotoIndex = selectedAlbumIndexs.last ?? 0
                }
            } else {
                selectedAlbumIndexs.append(indexPath.row)
                isSelected = true
                currentPhotoIndex = selectedAlbumIndexs.last ?? 0
            }
        } else {
            selectedAlbumIndexs.removeAll()
            selectedAlbumIndexs.append(indexPath.row)
            isSelected = true
            currentPhotoIndex = selectedAlbumIndexs.last ?? 0
        }
        
        
        collectionView.reloadData()
        delegate?.didSelectImages(at: selectedAlbumIndexs, isSelected: isSelected)
    }
}


class PhotoCell: UICollectionViewCell {
    
    var isMultiSelectEnabled: Bool = false {
        didSet {
            selectionView.isHidden = !isMultiSelectEnabled
            if !isMultiSelectEnabled {
                selectionLabel.isHidden = true
            }
        }
    }
    
    var indexPath: IndexPath?
        
    var _isSelected: Bool = false
    var selectedIndex: Int = -1
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let currentMaskView: UIView = {
        let currentMaskView = UIView()
        currentMaskView.isHidden = true
        currentMaskView.backgroundColor = .init(white: 1, alpha: 0.2)
        return currentMaskView
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
        contentView.addSubview(currentMaskView)
        contentView.addSubview(selectionLabel)
        contentView.addSubview(selectionView)
        
        selectionView.isHidden = true
        selectionView.image = UIImage(named: "publish_pic_unselectes")
        
        selectionLabel.isHidden = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgView.frame = contentView.bounds
        currentMaskView.frame = contentView.bounds
        selectionView.frame = CGRect(x: contentView.bounds.width - 22.5, y: 1.5, width: 21, height: 21)
        selectionLabel.frame = CGRect(x: contentView.bounds.width - 20, y: 4, width: 16, height: 16)
        
        toggleSelection()
        currentMaskView.isHidden = !_isSelected
        
    }
    
    func toggleSelection() {
        guard isMultiSelectEnabled else { return }
        
        selectionLabel.isHidden = selectedIndex < 0
        selectionLabel.text = String(selectedIndex+1)
    }
    
}
