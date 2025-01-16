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
