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
        
//        requestImageData()
    }
    
    func requestImageData() {
        HUDHelper.showHUD(view, text: "图片加载中...")

        photoAlbumManager.fetchAllImages { [weak self] images, assets in
            self?.allImages = images
            self?.allAssets = assets
            self?.photoAlbumView.images = images
            
            if let asset = assets.first {
                self?.photoAlbumManager.fetchOriginalImage(for: asset) { image in
                    self?.editImageView.image = image
                    HUDHelper.hideHUD(self?.view)
                }
            }
            
        }
    }
    
    
    func setupView() {
        
        setupNavView()
        
        editImageView.frame = CGRect.init(x: 0, y: .topSafeAreaHeight+40, width: .screenWidth, height: 400)
        editImageView.contentMode = .scaleAspectFit
        view.addSubview(editImageView)
       
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
        
        HUDHelper.showHUD(view, text: "加载中...")

        photoAlbumManager.fetchOriginalImages(for: selectedAssets) { [weak self] images in
            HUDHelper.hideHUD(self?.view)
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
//        editImageView.image = allImages[indexs.last ?? 0]
        let asset = allAssets[indexs.last ?? 0]
        self.photoAlbumManager.fetchOriginalImage(for: asset) { image in
            self.editImageView.image = image
        }
    }
    
}

