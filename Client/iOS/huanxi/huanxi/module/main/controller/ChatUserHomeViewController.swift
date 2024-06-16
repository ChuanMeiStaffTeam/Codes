//
//  ChatUserHomeViewController.swift
//  huanxi
//
//  Created by Jack on 2024/6/14.
//

import UIKit

class ChatUserHomeViewController: BaseViewController {
    
    let mineHeader = MineHeaderView(frame: CGRect(x: 0, y: .topBarHeight, width: .screenWidth, height: 165))
    var constrainerView: MineConstrainerView!

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    func setupView() {
        title = "用户首页"
        
        let addButton = UIButton(type: .custom)
        addButton.setImage(UIImage(named: "main_snapshot_add"), for: .normal)
        addButton.frame = CGRect(x: .screenWidth - 80, y: .topSafeAreaHeight + 5, width: 30, height:30)
        addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        let item1 = UIBarButtonItem.init(customView: addButton)
        
        let setButton = UIButton(type: .custom)
        setButton.setImage(UIImage(named: "main_more"), for: .normal)
        setButton.frame = CGRect(x: .screenWidth - 40, y: .topSafeAreaHeight + 5, width: 30, height: 30)
        setButton.addTarget(self, action: #selector(setAction), for: .touchUpInside)
        let item2 = UIBarButtonItem.init(customView: setButton)

        navigationItem.rightBarButtonItems = [item1, item2]
        
        view.addSubview(mineHeader)
        mineHeader.editHomePageBlock = {
            let vc = EditHomePageViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        constrainerView = MineConstrainerView(frame: CGRect.init(x: 0, y: mineHeader.bottom, width: .screenWidth, height: .screenHeight - mineHeader.bottom))
        view.addSubview(constrainerView)
    }
    
    
    @objc func addAction() {
        
    }
    
    @objc func setAction() {
        
    }
    
}
