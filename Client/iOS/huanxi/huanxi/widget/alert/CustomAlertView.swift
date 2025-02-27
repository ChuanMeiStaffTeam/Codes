//
//  CustomAlertView.swift
//  huanxi
//
//  Created by rslz on 2025/2/25.
//

import UIKit
import SDCAlertView

class CustomAlertView {

    // 显示自定义样式的 AlertView
    static func showCustomAlert(title: String? = nil, message: String? = nil, preferredStyle: AlertControllerStyle = .alert, actions: [AlertAction]) {
        // 创建 AlertController，title、message 和 preferredStyle 是可选的
        let alert = AlertController(title: title, message: message, preferredStyle: preferredStyle)

        // 自定义样式
        alert.visualStyle.normalTextColor = .white
        alert.visualStyle.preferredTextColor = .white
        alert.visualStyle.actionSheetPreferredFont = UIFont.systemFont(ofSize: 15)
        alert.visualStyle.actionSheetNormalFont = UIFont.systemFont(ofSize: 15) 
        alert.visualStyle.alertPreferredFont = UIFont.systemFont(ofSize: 15)
        alert.visualStyle.alertNormalFont = UIFont.systemFont(ofSize: 15)

        if preferredStyle == .actionSheet {
            alert.visualStyle.actionViewSize = CGSize(width: 90, height: 50)
            alert.visualStyle.actionViewSeparatorColor = .clear
        }

        // 添加按钮
        actions.forEach { action in
            alert.addAction(action)
        }

        // 显示 Alert
        alert.present()
    }
}

