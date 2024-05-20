//
//  MineViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit

class MineViewController: BaseViewController {
    
    
    let mineHeader = MineHeaderView(frame: CGRect(x: 0, y: .topSafeAreaHeight + 40, width: .screenWidth, height: 165))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    func setupView() {
        
        let nameLabel = UILabel(frame: CGRectMake(16, .topSafeAreaHeight, 200, 40))
        nameLabel.text = "Jack"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(nameLabel)
        
        let addButton = UIButton(type: .custom)
        addButton.setImage(UIImage(named: "main_snapshot_add"), for: .normal)
        addButton.frame = CGRectMake(.screenWidth - 80, .topSafeAreaHeight + 5, 30, 30)
        addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        view.addSubview(addButton)
        
        let setButton = UIButton(type: .custom)
        setButton.setImage(UIImage(named: "main_more"), for: .normal)
        setButton.frame = CGRectMake(.screenWidth - 40, .topSafeAreaHeight + 5, 30, 30)
        setButton.addTarget(self, action: #selector(setAction), for: .touchUpInside)
        view.addSubview(setButton)
        
        
        view.addSubview(mineHeader)
        mineHeader.editHomePageBlock = {
            let vc = EditHomePageViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    @objc func addAction() {
        
    }
    
    @objc func setAction() {
        
    }
}
