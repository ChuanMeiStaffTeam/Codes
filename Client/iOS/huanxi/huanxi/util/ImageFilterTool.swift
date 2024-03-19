//
//  ImageFilterTool.swift
//  huanxi
//
//  Created by jack on 2024/3/18.
//

import UIKit

class ImageFilterTool {
    
    // Apply filter to an input image
    static func applyFilter(to image: UIImage, filterType: String) -> UIImage? {
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        
        let context = CIContext()
        let filter = CIFilter(name: filterType)
        
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let outputImage = filter?.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        return nil
    }
}
