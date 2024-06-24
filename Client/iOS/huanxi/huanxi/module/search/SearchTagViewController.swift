//
//  SearchTagViewController.swift
//  huanxi
//
//  Created by jack on 2024/6/22.
//

import UIKit

class SearchTagViewController: BaseViewController {
    
    var images: [String] = ["list_0", "list_1", "list_2", "list_3", "list_4", "list_5", "list_6", "list_7", "list_8", "list_0", "list_1", "list_2", "list_3", "list_4", "list_5", "list_6", "list_7", "list_8","list_0", "list_1", "list_2", "list_3", "list_4", "list_5", "list_6", "list_7", "list_8","list_0", "list_1", "list_2", "list_3", "list_4", "list_5", "list_6", "list_7", "list_8"]

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        collectionView.reloadData()
    }
    
    
    func setupView() {
                
        view.addSubview(collectionView)
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        let cellWidth = (.screenWidth - 10) / 3
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        let collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: .screenWidth, height: .screenHeight), collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SearchImageCell.self, forCellWithReuseIdentifier: "cell")
        
        return collectionView
    }()
}

extension SearchTagViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchImageCell
        let imageStr = images[indexPath.item]
        cell.imgView.image = UIImage.init(named: imageStr)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


class SearchImageCell: UICollectionViewCell {

    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
        
    }
    
}
