//
//  PublishViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//
import UIKit

class PublishViewController: BaseViewController {
    
    var allImages: [UIImage] = []
    
    let photoAlbumManager = PhotoAlbumManager.shared
    let photoAlbumView = PhotoAlbumView()
    
    let editImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoAlbumManager.fetchSystemAlbums()
        
        setupView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        photoAlbumManager.fetchAllImages { images in
            self.allImages = images
            self.photoAlbumView.images = images
            self.photoAlbumView.toggleMultiSelect(enabled: true)
        }
    }
    
    
    func setupView() {
        
        editImageView.frame = CGRect.init(x: 0, y: 0, width: .screenWidth, height: 400)
        editImageView.contentMode = .scaleAspectFit
        view.addSubview(editImageView)
        
        
        photoAlbumView.frame = CGRect.init(x: 0, y: 450, width: .screenWidth, height: .screenHeight - 450)
        photoAlbumView.backgroundColor = .black
        photoAlbumView.delegate = self
        view.addSubview(photoAlbumView)
        
    }
    
}

extension PublishViewController: PhotoAlbumViewDelegate {
    func didSelectImage(at index: Int, isSelected: Bool) {
        guard allImages.count > index else {
            return
        }
        editImageView.image = allImages[index]
    }
    
}
