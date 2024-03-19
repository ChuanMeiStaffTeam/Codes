//
//  EditPhotoViewController.swift
//  huanxi
//
//  Created by jack on 2024/3/6.
//

import UIKit

struct FilterImage {
    
    var image: UIImage
    var name: String
    var type: String
}


class EditPhotoViewController: BaseViewController {
    
    var image: UIImage?
    
    let editImageView = UIImageView()
//    var imagesArr: [UIImage] = []
//    var filtersArr: [String] = ["Normal", "Calrendon", "Gingham", "Moon"]
    
    var filterImages: [FilterImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configImages()
    }
    
    func setupView() {
        
        setupNavView()
        
        editImageView.frame = CGRect.init(x: 0, y: .topSafeAreaHeight+40, width: .screenWidth, height: 400)
        editImageView.contentMode = .scaleAspectFit
        editImageView.image = image
        view.addSubview(editImageView)
        
        view.addSubview(collectionView)
    }
    
    func configImages()  {

        let filterNames = ["铬黄", "褪色", "即影即逝", "单色照片", "黑白", "冲印", "色调", "岁月痕迹", "晕影", "单色", "伪彩色", "最大组件", "最小组件", "颜色控制"]
        let filterTypes = ["CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CIVignette", "CIColorMonochrome", "CIFalseColor", "CIMaximumComponent", "CIMinimumComponent", "CIColorControls"]
        
        var index = 0
        if let image = self.image {
            for type in filterTypes {
                if let editedImage = ImageFilterTool.applyFilter(to: image, filterType: type) {
                    let name = filterNames[index]
                    let filterImage = FilterImage(image: editedImage, name: name, type: type)
                    filterImages.append(filterImage)
                }
                index += 1
            }
        }
        
        collectionView.reloadData()
    }
    
    func setupNavView() {
        let closeBtn = UIButton(type: .custom)
        closeBtn.setImage(UIImage.init(named: "publish_close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(CGFloat.topSafeAreaHeight+10)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "新发帖"
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.centerY.equalTo(closeBtn.snp.centerY).offset(0)
        }
        
        let continueBtn = UIButton(type: .custom)
        continueBtn.setTitle("继续", for: .normal)
        continueBtn.setTitleColor(.mainBlueColor, for: .normal)
        continueBtn.titleLabel?.font = .systemFont(ofSize: 16)
        continueBtn.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
        view.addSubview(continueBtn)
        continueBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(closeBtn.snp.centerY).offset(0)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
    }
    
    
    @objc func closeAction() {
        dismiss(animated: true)
    }
    
    @objc func continueAction() {
        
    }
    
    
    private let cellIdentifier = "EditPhotoCell"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 125)
        
        let collectionView = UICollectionView(frame: CGRect.init(x: 0, y: editImageView.bottom + 100, width: CGFloat.screenWidth, height: 125), collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EditPhotoCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        return collectionView
    }()
    
}


extension EditPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! EditPhotoCell
        let filter = filterImages[indexPath.row]
        cell.imgView.image = filter.image
        cell.filterLabel.text = filter.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = filterImages[indexPath.row]
        editImageView.image = filter.image
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        return edgeInsets
    }
}
