//
//  HUDHelper.swift
//  huanxi
//
//  Created by jack on 2024/2/29.
//

import Foundation
import UIKit
import MBProgressHUD

class HUDHelper {
    static func showHUD(_ view: UIView?, text: String) {
        DispatchQueue.main.async {
            guard let view = view ?? UIApplication.shared.windows.first(where: \.isKeyWindow) else {
                return
            }

            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = text
            hud.mode = .indeterminate
        }
    }

    static func hideHUD(_ view: UIView?) {
        DispatchQueue.main.async {
            guard let view = view ?? UIApplication.shared.windows.first(where: \.isKeyWindow) else {
                return
            }
            
            MBProgressHUD.hide(for: view, animated: true)
        }
    }

    static func showToast(_ text: String) {
        guard let view = UIApplication.shared.windows.first(where: \.isKeyWindow) else {
            return
        }
        showToast(view, text: text)
    }
    
    static func showToast(_ view: UIView, text: String) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.mode = .text
            hud.label.text = text
            hud.margin = 10
            hud.offset = CGPoint(x: 0, y: 0)
            hud.isUserInteractionEnabled = false
            hud.hide(animated: true, afterDelay: 2.0)
        }
    }
}
