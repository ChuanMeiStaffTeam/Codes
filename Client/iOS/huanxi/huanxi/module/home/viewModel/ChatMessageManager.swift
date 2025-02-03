//
//  ChatMessageManager.swift
//  huanxi
//
//  Created by Jack on 2024/6/7.
//

import UIKit
import NIMSDK

class ChatMessageManager: NSObject {
    
    static let chatTextFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    
    class func calculatCellHeight(message: NIMMessage) -> CGFloat {
        
        if message.messageType == .text {
            let height = TextSizeCalculator.calculateHeight(for: message.text ?? "",
                                                            with: chatTextFont,
                                                            maxWidth: .screenWidth - 130,
                                                            lineSpacing: 5)
            
            return height + 50
        } else if message.messageType == .image {
            return 100 + 50
        } else {
            return 0
        }
    }
    
    
    class func calculatTextWidth(message: NIMMessage) -> CGFloat {
        
        if message.messageType == .text {
            let text = message.text ?? ""
            let width = .screenWidth - 130
            let height = TextSizeCalculator.calculateHeight(for: text,
                                                            with: chatTextFont,
                                                            maxWidth: width,
                                                            lineSpacing: 5)
            if height < 20 {
                let labelWidth = TextSizeCalculator.calculateWidth(for: text,
                                                                  with: chatTextFont,
                                                           fixedHeight: 20)
                return labelWidth
            }
            return width
        } else if message.messageType == .image {
            return 0
        } else {
            return 0
        }
    }
    
}


/*代码功能
 
 这段代码定义了一个名为 ChatMessageManager 的类，用于管理聊天消息相关的一些计算和辅助方法。

 主要功能:

 calculatCellHeight(message:):

 根据消息类型计算聊天消息单元格的高度。
 如果是文本消息，则根据文本内容、字体、行间距等计算文本高度，并加上一定的边距。
 如果是图片消息，则返回一个固定的高度。
 对于其他类型的消息，返回 0。
 calculatTextWidth(message:):

 计算文本消息的宽度。
 对于文本消息，先计算文本的高度，如果高度小于 20，则根据文本内容计算实际宽度，否则返回最大宽度。
 对于其他类型的消息，返回 0。
 代码分析

 chatTextFont: 定义了一个静态常量，用于存储聊天文本的字体。
 calculatCellHeight:
 使用 TextSizeCalculator 类（未在代码中定义，可能是一个自定义的类）来计算文本的高度。
 根据消息类型进行不同的计算逻辑。
 calculatTextWidth:
 类似于 calculatCellHeight，根据文本内容和字体计算文本宽度。
 对于高度小于 20 的文本，计算实际宽度。
 可能的使用场景

 聊天界面布局: 在聊天界面中，根据消息类型和内容动态计算每个消息单元格的高度，以实现自适应布局。
 文本展示: 根据文本内容和宽度，计算文本的显示样式，例如换行、省略号等。
 进一步改进

 添加更多消息类型: 考虑支持更多类型的消息，例如语音消息、视频消息等。
 优化计算性能: 对于频繁的计算，可以考虑使用缓存机制来提高性能。
 添加单元格样式: 将单元格的样式（如背景色、边框等）也考虑在计算中。
 总结

 这段代码定义了一个简单的聊天消息管理器，提供了计算消息单元格高度和文本宽度的辅助方法。这些方法可以用于在聊天界面中实现自适应布局和优化文本展示。*/
