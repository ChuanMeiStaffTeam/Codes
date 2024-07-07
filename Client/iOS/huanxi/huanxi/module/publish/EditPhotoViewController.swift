//
//  EditPhotoViewController.swift
//  huanxi
//
//  Created by jack on 2024/3/6.
//

import UIKit
import TOCropViewController

struct FilterImage {
    
    var image: UIImage
    var name: String
    var type: String
}


class EditPhotoViewController: BaseViewController {
    
    var images: [UIImage] = []
    
    let editImageView = UIImageView()
    let editPhotosView = EditPhotosView()
    
    var filterImages: [FilterImage] = []
    var currentFliterImage: FilterImage?
    var editedImages: [UIImage] = []
    
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configImages()
    }
    
    func setupView() {
        
        setupNavView()
        
        editedImages = images
        editPhotosView.frame = CGRect.init(x: 0, y: .topSafeAreaHeight+40, width: .screenWidth, height: .screenWidth - 32)
        editPhotosView.images = editedImages
        editPhotosView.didSelectedItemBlock = { [weak self] (index) in
            self?.currentIndex = index
            self?.editPhotosView.currentIndex = index
        }
        view.addSubview(editPhotosView)
        
        view.addSubview(collectionView)
        
        view.addSubview(fillterButton)
        fillterButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(CGFloat.screenWidth/4.0-30)
            make.width.equalTo(60)
            make.bottom.equalToSuperview().offset(-CGFloat.bottomSafeAreaHeight-60)
        }
        
        view.addSubview(cropButton)
        cropButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(CGFloat.screenWidth/4.0*3-30)
            make.width.equalTo(60)
            make.bottom.equalToSuperview().offset(-CGFloat.bottomSafeAreaHeight-60)
        }
    }
    
    func configImages()  {

//        let filterNames = ["铬黄", "褪色", "即影即逝", "单色照片", "黑白", "冲印", "色调", "岁月痕迹", "晕影", "单色", "伪彩色", "最大组件", "最小组件", "颜色控制"]
//        let filterTypes = ["CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CIVignette", "CIColorMonochrome", "CIFalseColor", "CIMaximumComponent", "CIMinimumComponent", "CIColorControls"]
        
        let filterNames = ["铬黄", "褪色", "即影即逝","岁月痕迹", "单色"]
        let filterTypes = ["CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant","CIPhotoEffectTransfer","CIColorMonochrome"]
        
        var index = 0
        if let image = self.images.first {
            for type in filterTypes {
                if let editedImage = ImageFilterTool.applyFilter(to: image, filterType: type) {
                    let name = filterNames[index]
                    let filterImage = FilterImage(image: editedImage, name: name, type: type)
                    filterImages.append(filterImage)
                }
                index += 1
            }
        }
        if currentFliterImage == nil {
            currentFliterImage = filterImages.first
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
        let vc = ExplainViewController()
        vc.images = editedImages
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func clickFillterAction() {
        
    }
    
    @objc func clickCropAction() {
        let image = images[currentIndex]
        self.presentCropViewController(with: image)
    }
    
    private let cellIdentifier = "EditPhotoCell"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 125)
        
        let collectionView = UICollectionView(frame: CGRect.init(x: 0, y: editPhotosView.bottom + 100, width: CGFloat.screenWidth, height: 125), collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(EditPhotoCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        return collectionView
    }()
    
    private lazy var fillterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("滤镜", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickFillterAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var cropButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("裁剪", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickCropAction), for: .touchUpInside)
        return button
    }()
}


extension EditPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        currentFliterImage = filter
        updateEditedImages(type: filter.type)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        return edgeInsets
    }
    
    func updateEditedImages(type: String) {
        var editedImages: [UIImage] = []
        for image in images {
            if let editedImage = ImageFilterTool.applyFilter(to: image, filterType: type) {
                editedImages.append(editedImage)
            }
        }
        self.editedImages = editedImages
        editPhotosView.images = editedImages
    }
}


extension EditPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {

    func presentCropViewController(with image: UIImage) {
        let cropViewController = TOCropViewController(image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }

    // 图片裁剪完成后回调
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        // 使用裁剪后的图片
        cropViewController.dismiss(animated: true, completion: nil)
        images.replaceSubrange(0...0, with: [image])
        
        if let type = currentFliterImage?.type {
            updateEditedImages(type: type)
        }
        
        configImages()
    }

    // 图片裁剪取消回调
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
