//
//  MainViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit
import SwiftUI

class MainViewController: BaseViewController {
    
    let vm = MainViewModel()
    var mainView: MainView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        mainView.reloadMainViewData(vm.mainList)
    }
    
    
    func setupView() {
        setupNavView()
        
        mainView = MainView(frame: CGRect.init(x: 0, y: 0, width: .screenWidth, height: .screenHeight - .bottomSafeAreaHeight - .tabBarHeight))
        view.addSubview(mainView)
        
    }
    
    func setupNavView() {
        
        let imageView = UIImageView(image: UIImage.init(named: "instagram"))
        imageView.frame = CGRect(x: 16, y: 4	, width: 134, height: 36)
        let leftItem = UIBarButtonItem(customView: imageView)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: .screenWidth - 46, y: 7, width: 30, height: 30)
        button.setImage(UIImage.init(named: "main_relay"), for: .normal)
        button.addTarget(self, action: #selector(gotoDirect), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    
    @objc func gotoDirect() {
        let vc = DirectViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
