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
        
//        vm.requestHomePosts { [weak self] result in
//
//            if let data = self?.vm.data {
//                self?.mainView.reloadMainViewData(data)
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        LoginManager.requestUserInfo()
        
        requestMainPostData()
    }
    
    func requestMainPostData() {
        vm.requestHomePosts { [weak self] result in
            
            if let data = self?.vm.data {
                self?.mainView.reloadMainViewData(data)
            }
        }
    }
    
    
    func setupView() {
        setupNavView()
        
        mainView = MainView(frame: CGRect.init(x: 0, y: 0, width: .screenWidth, height: .screenHeight - .bottomSafeAreaHeight - .tabBarHeight))
        mainView.delegate = self
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


extension MainViewController: MainViewDelegate {
    func didClickMore(_ data: PostModel) {
        
    }
    
    func didClickLike(_ data: PostModel) {
        if (data.liked ?? false) {
            vm.requestCancelLikePost(params: ["postId": data.postId ?? 0]) { success in
                if success {
                    self.requestMainPostData()
                }
            }
        } else {
            vm.requestLikePost(params: ["postId": data.postId ?? 0]) { success in
                if success {
                    self.requestMainPostData()
                }
            }
        }
    }
    
    func didClickComment(_ data: PostModel) {
        
    }
    
    func didClickShare(_ data: PostModel) {
        
    }
    
    func didClickMark(_ data: PostModel) {
        if (data.favorite ?? false) {
            vm.requestCancelCollectPost(params: ["postId": data.postId ?? 0]) { success in
                if success {
                    self.requestMainPostData()
                }
            }
        } else {
            vm.requestCollectPost(params: ["postId": data.postId ?? 0]) { success in
                if success {
                    self.requestMainPostData()
                }
            }
        }
    }
}
