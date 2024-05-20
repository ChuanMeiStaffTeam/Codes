//
//  EditHomePageViewController.swift
//  huanxi
//
//  Created by Jack on 2024/5/20.
//

import UIKit

class EditHomePageViewController: BaseViewController {
    
    let iconImgView = UIImageView()
    let changeIconBtn = UIButton(type: .custom)
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        
        let backBtn = UIButton(type: .custom)
        backBtn.setTitle("取消", for: .normal)
        backBtn.setTitleColor(.white, for: .normal)
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(CGFloat.topSafeAreaHeight)
            make.height.equalTo(40)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "编辑主页"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.centerY.equalTo(backBtn).offset(0)
        }
        
        let completeBtn = UIButton(type: .custom)
        completeBtn.setTitle("完成", for: .normal)
        completeBtn.setTitleColor(.mainBlueColor, for: .normal)
        completeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        completeBtn.addTarget(self, action: #selector(completeAction), for: .touchUpInside)
        view.addSubview(completeBtn)
        completeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(CGFloat.topSafeAreaHeight)
            make.height.equalTo(40)
        }
        
        
        iconImgView.image = UIImage(named: "main_recommend_text")
        view.addSubview(iconImgView)
        iconImgView.layer.cornerRadius = 40
        iconImgView.layer.masksToBounds = true
        iconImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.width.height.equalTo(80)
        }
        
        changeIconBtn.setTitle("更换头像", for: .normal)
        changeIconBtn.setTitleColor(.mainBlueColor, for: .normal)
        changeIconBtn.titleLabel?.font = .systemFont(ofSize: 12)
        view.addSubview(changeIconBtn)
        changeIconBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.top.equalTo(iconImgView.snp.bottom).offset(12)
        }
        
        
        createLine(left: 0, top: .topSafeAreaHeight + 200)
        
        
        
    }
    
    func createLine(left: CGFloat, top: CGFloat) {
        let line = UIView(frame: CGRect(x: left, y: top, width: .screenWidth - left, height: 1))
        line.backgroundColor = .gray
        view.addSubview(line)
    }
    
    func createItem(title: String, value: String, top: CGFloat) {
//        let titleLabel = UILabel(frame: CGRect(x: <#T##Int#>, y: <#T##Int#>, width: <#T##Int#>, height: 46))
        
        
    }
    
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func completeAction() {
        
    }
}
