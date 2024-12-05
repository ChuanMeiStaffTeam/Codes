//
//  Notification+Extension.swift
//  huanxi
//
//  Created by rslz on 2024/11/11.
//

import Foundation
import UIKit

extension Notification {
    
    func keyBoardHeight() -> CGFloat {
        if let userInfo = self.userInfo {
            if let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let size = value.cgRectValue.size
                return UIInterfaceOrientation.portrait.isLandscape ? size.width : size.height
            }
        }
        return 0
    }
    
}


extension Notification.Name {
    static let postPublishSuccessNotification = Notification.Name("postPublishSuccessNotification")
}
