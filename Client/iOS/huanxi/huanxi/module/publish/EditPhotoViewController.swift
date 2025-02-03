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
        
        let filterNames = ["冷色调", "暖色调", "黑白", "单色"]
        let filterTypes = ["CIPhotoEffectProcess", "CIPhotoEffectTransfer", "CIPhotoEffectMono","CIColorMonochrome"]
        
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

/*代码功能概览
 
 这段代码主要实现了一个图片编辑功能。它允许用户：

 选择图片: 从已有的图片中选择一张进行编辑。
 应用滤镜: 对选中的图片应用各种滤镜效果。
 裁剪图片: 对图片进行裁剪。
 代码主要模块及功能

 EditPhotoViewController 类:

 主要作用: 负责整个图片编辑页面的视图控制和逻辑处理。
 关键属性:
 images: 存储所有待编辑的图片。
 filterImages: 存储所有滤镜效果的图片。
 currentFliterImage: 当前选中的滤镜。
 editedImages: 存储经过编辑后的图片。
 currentIndex: 当前选中的图片索引。
 主要方法:
 setupView: 配置界面布局，包括导航栏、图片预览视图、滤镜选择视图、裁剪按钮等。
 configImages: 初始化滤镜效果，将原始图片应用不同的滤镜生成新的图片。
 clickFillterAction: 点击滤镜按钮时触发，更新图片的滤镜效果。
 clickCropAction: 点击裁剪按钮时触发，弹出裁剪视图。
 updateEditedImages: 更新已编辑的图片数组。
 EditPhotosView 类:

 主要作用: 显示可供编辑的图片。
 关键属性:
 images: 要显示的图片数组。
 方法:
 通过 UICollectionView 展示图片，并提供点击事件回调。
 PhotoCell 类:

 主要作用: UICollectionView 的单元格，用于显示单个图片。
 关键属性:
 imgView: 显示图片的 UIImageView。
 filterLabel: 显示滤镜名称的 UILabel。
 代码逻辑

 用户进入 EditPhotoViewController。
 系统会初始化滤镜效果，并将原始图片应用不同的滤镜生成新的图片。
 用户可以在 EditPhotosView 中选择要编辑的图片。
 用户点击滤镜按钮，会应用选中的滤镜效果，并更新显示。
 用户点击裁剪按钮，会弹出裁剪视图，用户可以对图片进行裁剪。
 裁剪完成后，会更新图片并重新应用滤镜。
 代码亮点

 模块化设计: 将视图控制、图片处理等功能分模块实现，提高代码可维护性。
 滤镜效果: 支持多种滤镜效果，用户可以自由选择。
 图片裁剪: 集成了 TOCropViewController，方便用户进行图片裁剪。
 用户交互友好: 提供了直观的界面和交互方式。
 潜在改进

 性能优化: 可以考虑使用异步加载图片，避免卡顿。
 滤镜自定义: 可以提供自定义滤镜的功能。
 保存编辑后的图片: 可以提供保存编辑后的图片的功能。
 更多编辑功能: 可以增加更多的编辑功能，如旋转、缩放等。
 总结

 这段代码实现了基本的图片编辑功能，为用户提供了选择图片、应用滤镜、裁剪图片等操作。通过进一步的优化和扩展，可以打造更强大的图片编辑器。*/
