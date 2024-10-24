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
        
        vm.requestHomePosts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        mainView.reloadMainViewData(vm.mainList)
        
        LoginManager.requestUserInfo()
    }
    
    
    func setupView() {
        setupNavView()
        
        mainView = MainView(frame: CGRect.init(x: 0, y: 0, width: .screenWidth, height: .screenHeight - .bottomSafeAreaHeight - .tabBarHeight))
        view.addSubview(mainView)
        
    }
    
    func setupNavView() {
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 150, height: 40))
        view.backgroundColor = .clear
        
        let imageView = UIImageView(image: UIImage.init(named: "huanxi.jpg"))
        imageView.frame = CGRect(x: -10, y: 4, width: 72, height: 36)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        let leftItem = UIBarButtonItem(customView: view)
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
