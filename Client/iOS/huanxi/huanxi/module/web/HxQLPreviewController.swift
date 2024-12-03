//
//  HxQLPreviewController.swift
//  huanxi
//
//  Created by rslz on 2024/12/3.
//

import Foundation
import UIKit
import QuickLook

class HxQLPreviewController: QLPreviewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftButton = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(leftButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
        setupBaseView()
    }
    
    func setupBaseView() {
        view.backgroundColor = .white
    }
    
    
    // 按钮点击事件
    @objc func leftButtonTapped() {
        if let navigationController = self.navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
