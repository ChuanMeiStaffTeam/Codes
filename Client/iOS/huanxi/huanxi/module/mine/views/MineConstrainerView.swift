//
//  MineConstrainerView.swift
//  huanxi
//
//  Created by jack on 2024/6/16.
//

import UIKit

class MineConstrainerView: UIView {
    
    let scrollView = UIScrollView()
    let postBtn = UIButton.init(type: .custom)
    let markBtn = UIButton.init(type: .custom)
    let moveView = UIView()
    
    var postData: Array<[Int: PostModel.image]> = []
    var markData: Array<[Int: PostModel.image]> = []


    var images: [String] = ["list_0", "list_1", "list_2", "list_3", "list_4", "list_5", "list_6", "list_7", "list_8", "list_0", "list_1", "list_2", "list_3", "list_4", "list_5", "list_6", "list_7", "list_8","list_0", "list_1", "list_2", "list_3", "list_4", "list_5", "list_6", "list_7", "list_8","list_0", "list_1", "list_2", "list_3", "list_4", "list_5", "list_6", "list_7", "list_8"]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadPostData(_ data: Array<[Int: PostModel.image]>) {
        postData = data
        postCollectionView.reloadData()
    }
    
    func reloadMarkData(_ data: Array<[Int: PostModel.image]>) {
        markData = data
        markCollectionView.reloadData()
    }
    
    @objc func postAction() {
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    
    @objc func markAction() {
        scrollView.setContentOffset(CGPoint.init(x: self.width, y: 0), animated: true)
    }
    
    func setupView() {
    
        
        postBtn.setImage(UIImage.init(named: "mine_post"), for: .normal)
        postBtn.addTarget(self, action: #selector(postAction), for: .touchUpInside)
        postBtn.frame = CGRect.init(x: 0, y: 0, width: self.width / 2.0, height: 50)
        addSubview(postBtn)
        
        markBtn.setImage(UIImage.init(named: "mine_mark"), for: .normal)
        markBtn.addTarget(self, action: #selector(markAction), for: .touchUpInside)
        markBtn.frame = CGRect.init(x: self.width / 2.0, y: 0, width: self.width / 2.0, height: 50)
        addSubview(markBtn)
        
        
        scrollView.isPagingEnabled = true
        scrollView.frame = CGRect.init(x: 0, y: 50, width: self.width, height: self.height - 50)
        scrollView.contentSize = CGSize.init(width: self.width * 2, height: 0)
        addSubview(scrollView)
        
        scrollView.addSubview(postCollectionView)
        scrollView.addSubview(markCollectionView)
    
    }
    
    
    private lazy var postCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        let cellWidth = (self.width - 10) / 3
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        let collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: self.scrollView.width, height: self.scrollView.height), collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        
        return collectionView
    }()
    
    private lazy var markCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        let cellWidth = (self.width - 10) / 3
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        let collectionView = UICollectionView(frame: CGRect.init(x: self.scrollView.width, y: 0, width: self.scrollView.width, height: self.scrollView.height), collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        
        return collectionView
    }()
}


extension MineConstrainerView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == postCollectionView {
            return postData.count
        } else {
            return markData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == postCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
            if let image = postData[indexPath.item].values.first, let imageStr = image.imageUrl {
                cell.imgView.kf.setImage(with: URL.init(string: imageStr))
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
            if let image = markData[indexPath.item].values.first, let imageStr = image.imageUrl {
                cell.imgView.kf.setImage(with: URL.init(string: imageStr))
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}



class ImageCell: UICollectionViewCell {

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
