//
//  PhotoAlbumManager.swift
//  huanxi
//
//  Created by jack on 2024/3/2.
//

import UIKit
import Photos

class PhotoAlbumManager {
    
    static let shared = PhotoAlbumManager()
    
    var albums: [PHAssetCollection] = []
    var images: [UIImage] = []
    
    func fetchSystemAlbums() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        
        smartAlbums.enumerateObjects { album, _, _ in
            self.albums.append(album)
        }
    }
    
    func fetchAllImages(completion: @escaping ([UIImage], [PHAsset]) -> Void) {
        // 请求相册访问权限
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                print("相册访问被拒绝")
                completion([], [])
                return
            }
            
            DispatchQueue.global().async {
                var allImages: [UIImage] = []
                var allAssets: [PHAsset] = []
                
                // 设置查询选项
                let fetchOptions = PHFetchOptions()
                fetchOptions.fetchLimit = 50 // 限制最多获取 50 张照片
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)] // 按创建时间降序排列
                // 添加过滤条件，仅获取静态图片（排除视频和实况图片）
                fetchOptions.predicate = NSPredicate(format: "mediaType == %d AND NOT (mediaSubtype == %d)", PHAssetMediaType.image.rawValue, PHAssetMediaSubtype.photoLive.rawValue)
                
                // 设置图片加载选项
                let requestOptions = PHImageRequestOptions()
                requestOptions.deliveryMode = .fastFormat       // 底质量图片
                requestOptions.isNetworkAccessAllowed = true     // 允许从 iCloud 加载
                requestOptions.isSynchronous = false           // 异步加载
                
                // 获取所有相册
                let albums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
                
                // 遍历所有相册中的照片资源
                albums.enumerateObjects { album, _, _ in
                    let assets = PHAsset.fetchAssets(in: album, options: fetchOptions)
                    assets.enumerateObjects { asset, _, _ in
                        allAssets.append(asset)
                    }
                }
                
                // 获取总资源数
                let totalAssets = allAssets.count
                guard totalAssets > 0 else {
                    DispatchQueue.main.async {
                        completion([], [])
                    }
                    return
                }
                
                // 用于跟踪图片加载完成的计数器
                var processedCount = 0
                
                // 遍历所有资源并加载图片
                for asset in allAssets {
                    PHImageManager.default().requestImage(
                        for: asset,
                        targetSize: CGSize(width: 500, height: 500), // 设置目标大小，避免加载全分辨率
                        contentMode: .aspectFill,
                        options: requestOptions
                    ) { image, _ in
                        if let image = image {
                            allImages.append(image)
                        }
                        
                        // 更新已处理的资源计数
                        processedCount += 1
                        if processedCount == totalAssets {
                            // 所有图片加载完成后回调
                            DispatchQueue.main.async {
                                completion(allImages, allAssets)
                            }
                        }
                    }
                }
            }
        }
    }
//    func fetchAllImages(completion: @escaping ([UIImage]) -> Void) {
//        var allImages: [UIImage] = []
//
//        DispatchQueue.global().async {
//            let fetchOptions = PHFetchOptions()
//            fetchOptions.fetchLimit = 50 // 每次只获取50张图片
//
//            let albums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: fetchOptions)
//
//            let requestOptions = PHImageRequestOptions()
//            requestOptions.deliveryMode = .fastFormat // 使用快速格式以减少内存占用
//            requestOptions.isSynchronous = true // 使请求同步执行
//
//            albums.enumerateObjects { album, _, _ in
//                let assets = PHAsset.fetchAssets(in: album, options: nil)
//
//                assets.enumerateObjects { asset, _, _ in
//                    let targetSize = CGSize(width: 100, height: 100) // 设定缩略图尺寸
//                    PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions) { image, _ in
//                        if let image = image {
//                            allImages.append(image)
//                        }
//
//                        if allImages.count == assets.count {
//                            DispatchQueue.main.async {
//                                completion(allImages)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
    // 加载原图
    func fetchOriginalImage(for asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let requestOptions = PHImageRequestOptions()
            requestOptions.deliveryMode = .highQualityFormat // 高质量图片
            requestOptions.isNetworkAccessAllowed = true     // 允许从 iCloud 加载
            requestOptions.isSynchronous = true             // 同步加载
            PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: requestOptions) { image, _ in
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
    
    func fetchOriginalImages(for assets: [PHAsset], completion: @escaping ([UIImage]?) -> Void) {
        var allImages: [UIImage] = []

        assets.forEach { asset in
            fetchOriginalImage(for: asset) { image in
                if let image = image {
                    allImages.append(image)
                }

                if allImages.count == assets.count {
                    DispatchQueue.main.async {
                        completion(allImages)
                    }
                }
            }
        }
    }

    
    func fetchImagesFromAlbum(at index: Int) {
        guard index < albums.count else { return }
        
        images.removeAll()
        
        let album = albums[index]
        let fetchOptions = PHFetchOptions()
        let assets = PHAsset.fetchAssets(in: album, options: fetchOptions)
        
        assets.enumerateObjects { asset, _, _ in
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { image, _ in
                if let image = image {
                    self.images.append(image)
                }
            }
        }
    }
}
