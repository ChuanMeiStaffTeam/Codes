//
//  Constants.swift
//  huanxi
//
//  Created by rslz on 2024/11/11.
//

import Foundation
import UIKit


let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

func getKeyWindow() -> UIWindow? {
    if #available(iOS 13, *) {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    } else {
        return UIApplication.shared.keyWindow
    }
}
