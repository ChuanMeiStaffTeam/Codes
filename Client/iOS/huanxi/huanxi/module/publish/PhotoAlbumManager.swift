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
        
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
        smartAlbums.enumerateObjects { album, _, _ in
            self.albums.append(album)
        }
    }
    
    func fetchAllImages(completion: @escaping ([UIImage]) -> Void) {
        var allImages: [UIImage] = []
        
        DispatchQueue.global().async {
            let fetchOptions = PHFetchOptions()
            let albums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: fetchOptions)
            fetchOptions.fetchLimit = 50
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.deliveryMode = .highQualityFormat
            

            
            albums.enumerateObjects { album, _, _ in
                let assets = PHAsset.fetchAssets(in: album, options: nil)
                
                if assets.count > 0 {
                    print("相册名：" + (album.localizedTitle ?? "") + "    照片数量" + String(assets.count))
                }

                assets.enumerateObjects { asset, _, _ in
                    PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: requestOptions) { image, _ in
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
