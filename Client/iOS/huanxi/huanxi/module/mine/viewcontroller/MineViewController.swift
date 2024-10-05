//
//  MineViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit

class MineViewController: BaseViewController {
    
    
    let mineHeader = MineHeaderView(frame: CGRect(x: 0, y: .topSafeAreaHeight + 40, width: .screenWidth, height: 165))
    var constrainerView: MineConstrainerView!
    let nameLabel = UILabel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        requestUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        requestUserPosts()
        requestUserMark()
    }
    
    func requestUserInfo() {
        NetworkManager.shared.getRequest(urlStr: "userinfo/getUserInfo",
                                         parameters: nil,
                                         responseType: UserInfoResponse.self) { success, message, data in
            if success, let user = data?.user {
                self.updateData(user)
            }
//            HUDHelper.showToast(message)
        }
    }
    
    func requestUserPosts() {
        NetworkManager.shared.getRequest(urlStr: "postImage/queryPosts",
                                         parameters: nil,
                                         responseType: PostsResponse.self) { success, message, data in
            if success, let list = data?.list {
                var postImages: Array<[Int: PostModel.image]> = []
                for item in list {
                    for image in (item.images ?? []) {
                        if let postId = item.postId {
                            let postImage: [Int: PostModel.image] = [postId: image]
                            postImages.append(postImage)
                        }
                    }
                }
                
                self.constrainerView.reloadPostData(postImages)
            }
        }
    }
    
    func requestUserMark() {
        NetworkManager.shared.getRequest(urlStr: "postImage/queryCollectedPosts",
                                         parameters: nil,
                                         responseType: PostsResponse.self) { success, message, data in
            if success, let list = data?.list {
                var postImages: Array<[Int: PostModel.image]> = []
                for item in list {
                    for image in (item.images ?? []) {
                        if let postId = item.postId {
                            let postImage: [Int: PostModel.image] = [postId: image]
                            postImages.append(postImage)
                        }
                    }
                }
                
                self.constrainerView.reloadMarkData(postImages)
            }
        }
    }
    
    func updateData(_ info: UserInfoModel) {
        
        nameLabel.text = info.fullName
        
        mineHeader.reloadData(info)
    }
    
    func setupView() {
        
        nameLabel.frame = CGRect(x: 16, y: .topSafeAreaHeight, width: 200, height: 40)
        nameLabel.text = "--"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(nameLabel)
        
        let addButton = UIButton(type: .custom)
        addButton.setImage(UIImage(named: "main_snapshot_add"), for: .normal)
        addButton.frame = CGRect(x: .screenWidth - 80, y: .topSafeAreaHeight + 5, width: 30, height:30)
        addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        view.addSubview(addButton)
        
        let setButton = UIButton(type: .custom)
        setButton.setImage(UIImage(named: "main_more"), for: .normal)
        setButton.frame = CGRect(x: .screenWidth - 40, y: .topSafeAreaHeight + 5, width: 30, height: 30)
        setButton.addTarget(self, action: #selector(setAction), for: .touchUpInside)
        view.addSubview(setButton)
        
        
        view.addSubview(mineHeader)
        mineHeader.editHomePageBlock = {
            let vc = EditHomePageViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        constrainerView = MineConstrainerView(frame: CGRect.init(x: 0, y: mineHeader.bottom, width: .screenWidth, height: .screenHeight - mineHeader.bottom - .tabBarHeight - .bottomSafeAreaHeight))
        view.addSubview(constrainerView)

    }
    
    
    @objc func addAction() {
        
    }
    
    @objc func setAction() {
        let vc = SettingViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
