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
        
        var itemTop = .topSafeAreaHeight + 200
        createItem(title: "姓名", value: "小摩", top: itemTop)
        itemTop = itemTop + 46
        
        createItem(title: "账号", value: "xiaomo", top: itemTop)
        itemTop = itemTop + 46
        
        createItem(title: "网站", value: "www.baidu.com", top: itemTop)
        itemTop = itemTop + 46
        
        createItem(title: "个性签名", value: "设计+协作，摹客就够了！", top: itemTop, lineHidden: true)
        itemTop = itemTop + 46
        
        createLine(left: 0, top: itemTop)
        let titleLabel1 = UILabel(frame: CGRect(x: 20, y: itemTop, width: 100, height: 46))
        titleLabel1.text = "切换为专业账户"
        titleLabel1.textColor = .mainBlueColor
        titleLabel1.font = .systemFont(ofSize: 14)
        view.addSubview(titleLabel1)
        
        
        itemTop = itemTop + 46
        createLine(left: 0, top: itemTop)
        let titleLabel2 = UILabel(frame: CGRect(x: 20, y: itemTop, width: 100, height: 46))
        titleLabel2.text = "个人信息设置"
        titleLabel2.textColor = .mainBlueColor
        titleLabel2.font = .systemFont(ofSize: 14)
        view.addSubview(titleLabel2)
        
        
    }
    
    func createLine(left: CGFloat, top: CGFloat) {
        let line = UIView(frame: CGRect(x: left, y: top, width: .screenWidth - left, height: 0.5))
        line.backgroundColor = .gray
        view.addSubview(line)
    }
    
    func createItem(title: String, value: String, top: CGFloat, lineHidden: Bool = false) {
        let titleLabel = UILabel(frame: CGRect(x: 20, y: top, width: 100, height: 46))
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14)
        view.addSubview(titleLabel)
        
        let valueLabel = UILabel(frame: CGRect(x: 120, y: top, width: 200, height: 46))
        valueLabel.text = value
        valueLabel.textColor = .white
        valueLabel.font = .systemFont(ofSize: 14)
        view.addSubview(valueLabel)
        
        if !lineHidden {
            createLine(left: 120, top: top + 45)
        }
    }
    
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func completeAction() {
        
    }
}
