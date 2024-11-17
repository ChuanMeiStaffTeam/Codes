//
//  LaunchViewController.swift
//  huanxi
//
//  Created by rslz on 2024/11/17.
//

import Foundation
import UIKit

class LaunchViewController: UIViewController {
    private var _launchView: UIView?
    private var launchView: UIView? {
        if _launchView == nil {
            let launchView = Bundle.main.loadNibNamed("LaunchScreen", owner: nil, options: nil)?[0] as? UIView
            launchView?.frame = view.bounds
            _launchView = launchView
        }
        return _launchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let launchView {
            view.addSubview(launchView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
