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
                fetchOptions.fetchLimit = 200 // 限制最多获取 200 张照片
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


/*代码功能概述

这段代码主要实现了一个用于管理相册图片的类 PhotoAlbumManager。它提供了以下功能：

获取系统相册: 从设备中获取所有相册。
获取所有图片: 从所有相册中获取所有图片。
获取原图: 获取指定资源的原始图像。
获取多个资源的原图: 获取多个资源的原始图像。
从特定相册获取图片: 从指定相册中获取图片。
代码详细分析

PhotoAlbumManager 类:

属性:
albums: 存储获取到的所有相册的数组。
images: 存储获取到的所有图片的数组。
delegate: 用于将选择结果传递给其他模块的代理。
方法:
fetchSystemAlbums(): 获取系统相册，并将结果存储在 albums 属性中。
fetchAllImages(completion:): 获取所有相册中的所有图片，并通过 completion 回调返回结果。
fetchOriginalImage(for:completion:): 获取指定资源的原始图像。
fetchOriginalImages(for:completion:): 获取多个资源的原始图像。
fetchImagesFromAlbum(at:): 从指定相册中获取图片。
PhotoAlbumView 类:

属性:
images: 要显示的图片数组。
selectedAlbumIndexs: 已选中的图片索引数组。
currentPhotoIndex: 当前选中的图片索引。
isMultiSelectEnabled: 是否启用多选模式。
collectionView: 用于显示图片的 UICollectionView。
方法:
toggleMultiSelect(enabled:): 切换多选模式。
UICollectionViewDataSource 和 UICollectionViewDelegate 协议的方法：用于配置和处理 UICollectionView 的数据源和代理事件。
PhotoCell 类:

属性:
isMultiSelectEnabled: 是否启用多选模式。
indexPath: Cell 在 collectionView 中的索引路径。
_isSelected: 是否选中。
selectedIndex: 在选中数组中的索引。
imgView: 用于显示图片的 UIImageView。
currentMaskView: 用于高亮当前选中图片的视图。
selectionView: 用于显示选中状态的视图。
selectionLabel: 用于显示选中索引的标签。
方法:
toggleSelection(): 根据选中状态更新 Cell 的外观。
代码逻辑

PhotoAlbumManager 主要负责从系统相册获取图片数据，并提供给 PhotoAlbumView 使用。
PhotoAlbumView 使用 UICollectionView 来展示图片，并处理用户的选择操作。
PhotoCell 是 UICollectionView 的单元格，负责显示单个图片，并根据选中状态显示不同的样式。
代码优缺点

优点:
代码结构清晰，职责分明。
充分利用了 Photos 框架的功能。
提供了灵活的图片获取方式。
考虑了多选功能。
缺点:
缺少详细的错误处理。
可以考虑添加缓存机制，提高性能。
可以提供更多的自定义选项。
改进建议

错误处理: 可以添加更多的错误处理，比如网络错误、相册权限被拒绝等。
缓存: 可以实现图片缓存，避免重复加载相同的图片。
性能优化: 可以优化图片加载过程，减少内存占用。
自定义: 可以提供更多的自定义选项，比如自定义单元格样式、加载图片的大小等。
异步操作: 可以使用异步操作，避免阻塞主线程。
总结

这段代码实现了从系统相册获取图片并展示的功能，代码结构清晰，功能相对完善。但仍有优化空间，可以进一步提高代码的健壮性和性能。
 */
