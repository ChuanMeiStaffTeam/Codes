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

/*代码分析：图像滤镜处理工具
 代码功能

 这段 Swift 代码定义了一个名为 ImageFilterTool 的类，提供了一个静态方法 applyFilter(to:filterType:)，用于对给定的 UIImage 应用指定的 Core Image 滤镜。

 工作流程

 输入:

 UIImage 对象：待处理的原始图像。
 filterType 字符串：指定要应用的滤镜名称。
 CIImage 转换:

 将输入的 UIImage 对象转换为 CIImage 对象，以便使用 Core Image 进行处理。
 创建滤镜:

 根据 filterType 字符串创建一个 CIFilter 对象。
 应用滤镜:

 将输入的 CIImage 设置为滤镜的输入图像。
 获取滤镜处理后的输出图像。
 生成 UIImage:

 将滤镜处理后的 CIImage 转换为 CGImage，再转换为 UIImage。
 返回结果:

 返回处理后的 UIImage 对象，或者在发生错误时返回 nil。
 核心概念

 CIFilter: Core Image 提供的滤镜类，用于对图像进行各种处理。
 CIImage: Core Image 中表示图像的类，是图像处理的基本单位。
 CIContext: 用于渲染 Core Image 图像的上下文。
 代码优势

 封装性好: 将图像滤镜处理封装成一个静态方法，使用方便。
 灵活: 可以应用各种 Core Image 提供的滤镜。
 易于扩展: 可以通过添加更多的滤镜类型或自定义滤镜来扩展功能。
 使用示例

 Swift

 let originalImage = UIImage(named: "myImage")
 if let filteredImage = ImageFilterTool.applyFilter(to: originalImage!, filterType: "CISepiaTone") {
     // 使用滤镜后的图像
 }
 注意事项

 滤镜名称: 确保 filterType 字符串与 Core Image 提供的滤镜名称一致。
 性能: 对于大尺寸图像或复杂的滤镜，处理过程可能会消耗较多资源。
 错误处理: 可以添加更多的错误处理逻辑，例如处理滤镜创建失败的情况。
 拓展

 自定义滤镜: 可以通过创建自定义的 CIFilter 来实现更复杂的图像处理效果。
 参数调整: 可以通过设置 CIFilter 的参数来调整滤镜的效果。
 批量处理: 可以将多个图像进行批量处理。
 异步处理: 对于耗时较长的滤镜处理，可以考虑使用异步操作。
*/
