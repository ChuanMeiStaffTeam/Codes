//
//  BaseViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import Foundation
import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseView()
    }
    
    func setupBaseView() {
        view.backgroundColor = .black
    }
    
    @objc func onBackTap() {
        if (self.navigationController != nil) && (self.navigationController?.viewControllers.count ?? 0) > 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
}

