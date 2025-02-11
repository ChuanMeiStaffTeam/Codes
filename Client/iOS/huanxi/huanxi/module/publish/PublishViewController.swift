//
//  PublishViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//
import UIKit
import Photos

class PublishViewController: BaseViewController {
    
    var allImages: [UIImage] = []
    var allAssets: [PHAsset] = []

    var indexs: [Int] = [0]
    
    let photoAlbumManager = PhotoAlbumManager.shared
    let photoAlbumView = PhotoAlbumView()
    
    let editImageView = UIImageView()
    let editImageViewActivityIndicator = UIActivityIndicatorView(style: .medium)

    let editView = UIView()
    let albumNameLabel = UILabel()
    let albumArrow = UIImageView()
    let multiSelectBtn = UIButton()
    let photoBtn = UIButton()
    
    private var isMultiSelectEnabled: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoAlbumManager.fetchSystemAlbums()
        
        setupView()
        requestImageData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func requestImageData() {
        HUDHelper.showHUD(in: view, text: "图片加载中...")

        photoAlbumManager.fetchAllImages { [weak self] images, assets in
            self?.allImages = images
            self?.allAssets = assets
            self?.photoAlbumView.images = images
            
            if let asset = assets.first {
                self?.photoAlbumManager.fetchOriginalImage(for: asset) { image in
                    self?.editImageView.image = image
                    HUDHelper.hideHUD(in: self?.view)
                }
            }
            
        }
    }
    
    
    func setupView() {
        
        setupNavView()
        
        editImageView.frame = CGRect.init(x: 0, y: .topSafeAreaHeight+40, width: .screenWidth, height: 400)
        editImageView.contentMode = .scaleAspectFit
        view.addSubview(editImageView)
        
        // 配置指示器
        editImageViewActivityIndicator.color = .gray
        editImageView.addSubview(editImageViewActivityIndicator)
        editImageViewActivityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
       
        setupEditView()
        
        photoAlbumView.frame = CGRect.init(x: 0, y: editView.bottom, width: .screenWidth, height: .screenHeight - editView.bottom - .bottomSafeAreaHeight)
        photoAlbumView.backgroundColor = .black
        photoAlbumView.delegate = self
        view.addSubview(photoAlbumView)
        
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
    
    func setupEditView() {
        
        editView.frame = CGRect.init(x: 0, y: editImageView.bottom, width: .screenWidth, height: 62)
        editView.backgroundColor = .black
        view.addSubview(editView)
        
        let changeAlbumBtn = UIButton(type: .custom)
        changeAlbumBtn.addTarget(self, action: #selector(changeAlbumAction), for: .touchUpInside)
        editView.addSubview(changeAlbumBtn)
        
        albumNameLabel.textColor = .white
        albumNameLabel.text = "最近项目"
        albumNameLabel.font = .systemFont(ofSize: 12)
        changeAlbumBtn.addSubview(albumNameLabel)
        albumNameLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().offset(0)
        }
        
        
        albumArrow.image = UIImage.init(named: "publish_arrow_down")
        changeAlbumBtn.addSubview(albumArrow)
        albumArrow.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(0)
            make.left.equalTo(albumNameLabel.snp.right).offset(6)
            make.height.width.equalTo(15)
            make.centerY.equalToSuperview().offset(0)
        }
        
        changeAlbumBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.bottom.equalToSuperview().offset(0)
        }
        
        multiSelectBtn.setImage(UIImage.init(named: "publish_multiSelect"), for: .normal)
        multiSelectBtn.setTitle("  选择多项", for: .normal)
        multiSelectBtn.setTitleColor(.white, for: .normal)
        multiSelectBtn.titleLabel?.font = .systemFont(ofSize: 12)
        multiSelectBtn.backgroundColor = .init(white: 1, alpha: 0.15)
        multiSelectBtn.layer.cornerRadius = 15
        multiSelectBtn.layer.masksToBounds = true
        multiSelectBtn.addTarget(self, action: #selector(multiSelectAction), for: .touchUpInside)
        editView.addSubview(multiSelectBtn)
        multiSelectBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-62)
            make.width.equalTo(108)
            make.height.equalTo(30)
            make.centerY.equalToSuperview().offset(0)
        }
        
        photoBtn.setImage(UIImage.init(named: "publish_camera"), for: .normal)
        photoBtn.layer.cornerRadius = 15
        photoBtn.layer.masksToBounds = true
        photoBtn.backgroundColor = .init(white: 1, alpha: 0.15)
        photoBtn.addTarget(self, action: #selector(cameraAction), for: .touchUpInside)
        editView.addSubview(photoBtn)
        photoBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(30)
        }
        
        
        
    }
    
    @objc func closeAction() {
        dismiss(animated: true)
    }
    
    @objc func continueAction() {
        guard !indexs.isEmpty else {
            HUDHelper.showToast("请先选择照片")
            return
        }
        
        let selectedAssets = indexs.map {
            allAssets[$0]
        }
        
        HUDHelper.showHUD(text: "加载中...")

        photoAlbumManager.fetchOriginalImages(for: selectedAssets) { [weak self] images in
            HUDHelper.hideHUD()
            let vc = EditPhotoViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.images = images ?? []
            self?.present(vc, animated: true)
        }
//        let images = indexs.map {
//            allImages[$0]
//        }
    }
    
    @objc func changeAlbumAction() {
        
        
    }
    
    @objc func multiSelectAction() {
        isMultiSelectEnabled = !isMultiSelectEnabled
        self.photoAlbumView.toggleMultiSelect(enabled: isMultiSelectEnabled)
    }
    
    @objc func cameraAction() {
        
    }
    
}

extension PublishViewController: PhotoAlbumViewDelegate {
    func didSelectImages(at indexs: [Int], isSelected: Bool) {
        guard indexs.count > 0, allImages.count > indexs.last ?? 0 else {
            return
        }
        self.indexs = indexs
        let asset = allAssets[indexs.last ?? 0]
        
        //先设置缩略图，再异步加载原图
        let thumpImage = allImages[indexs.last ?? 0]
        self.editImageView.image = thumpImage
        // 启动指示器
        editImageViewActivityIndicator.startAnimating()
        self.photoAlbumManager.fetchOriginalImage(for: asset) { image in
            DispatchQueue.main.async {
                self.editImageView.image = image
                self.editImageViewActivityIndicator.stopAnimating()
            }
        }
    }
    
}

/*代码功能概览
 
 这段 Swift 代码主要实现了一个 iOS 应用中的图片发布功能。用户可以通过这个功能选择手机中的图片，并进行一些基本的编辑操作（如选择相册、多选图片等），最终发布这些图片。

 代码主要模块及功能

 PublishViewController 类:

 主要作用: 负责整个发布页面的视图控制和逻辑处理。
 关键属性:
 allImages: 存储设备中所有图片的数组。
 allAssets: 存储图片对应的 PHAsset 对象的数组。
 indexs: 记录用户选择的图片索引。
 photoAlbumManager: 用于管理相册的工具类。
 photoAlbumView: 展示相册图片的视图。
 editImageView: 显示当前选中的图片。
 editView: 包含选择相册、多选、拍照等操作按钮的视图。
 主要方法:
 viewDidLoad: 初始化视图，请求图片数据。
 viewDidAppear: 视图出现时的一些处理。
 requestImageData: 请求设备中所有图片数据。
 setupView: 配置界面布局。
 setupNavView: 配置导航栏。
 setupEditView: 配置编辑视图。
 事件处理:
 closeAction: 关闭页面。
 continueAction: 继续下一步操作（如编辑图片）。
 changeAlbumAction: 切换相册。
 multiSelectAction: 切换多选模式。
 cameraAction: 打开相机。
 PhotoAlbumView 类:

 主要作用: 展示相册图片，并处理图片选择事件。
 关键属性:
 images: 显示的图片数组。
 主要方法:
 toggleMultiSelect: 切换多选模式。
 代码逻辑流程

 进入 PublishViewController，初始化视图和数据。
 请求设备中所有图片数据，并展示在 photoAlbumView 中。
 用户选择图片，触发 didSelectImages 回调。
 根据用户选择，更新 editImageView 显示的图片。
 用户点击“继续”按钮，进入下一步操作（如编辑图片）。
 代码亮点

 模块化设计: 将视图控制、数据管理、相册展示等功能分模块实现，提高代码可维护性。
 异步加载图片: 异步加载图片，避免主线程卡顿。
 多选功能: 支持多选图片。
 相册管理: 使用 PhotoAlbumManager 类方便管理相册。
 潜在改进点

 图片编辑功能: 目前仅支持选择图片，可以增加图片编辑功能（如裁剪、滤镜等）。
 性能优化: 如果图片数量较多，可以考虑优化图片加载和显示性能。
 用户体验: 可以增加一些动画效果，提升用户体验。
 错误处理: 可以增加一些错误处理，比如网络请求失败、图片加载失败等。
 代码细节问题

 PhotoAlbumManager 类: 代码中没有提供该类的具体实现，无法详细分析。
 HUDHelper 类: 代码中使用了 HUDHelper 类显示加载提示，但没有提供该类的实现。
 mainBlueColor: 代码中使用了 mainBlueColor，但没有定义其具体值。
 总结

 这段代码实现了一个功能相对完善的图片发布功能，但仍有一些可以改进的地方。如果您想深入了解代码的细节，建议您查看 PhotoAlbumManager、HUDHelper 等类的具体实现，并结合您的项目需求进行修改和优化。*/
