//
//  CompanyViewController.swift
//  huanxi
//
//  Created by jack on 2024/9/13.
//

import UIKit
import SwiftUI

class CompanyViewController: BaseViewController {
    
    let companyNameTF = UITextField()
    let companyCodeTF = UITextField()
    let nameTF = UITextField()
    let phoneTF = UITextField()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        title = "企业信息"
        
        let titleLabel = UILabel()
        titleLabel.text = "输入企业营业执照信息"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(CGFloat.topBarHeight+20)
        }
        
        let descLabel = UILabel()
        descLabel.text = "填写正确的企业和联系人信息，否则无法验证"
        descLabel.textColor = .white
        descLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        companyNameTF.placeholder = "请输入企业名称（必填）"
        companyNameTF.font = UIFont.boldSystemFont(ofSize: 16)
        companyNameTF.setPlaceholderColor(.gray)
        companyNameTF.textColor = .white
        view.addSubview(companyNameTF)
        companyNameTF.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(descLabel.snp.bottom).offset(35)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
        
        let line1 = UIView()
        line1.backgroundColor = UIColor.init(hexString: "#666666")
        view.addSubview(line1)
        line1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(companyNameTF.snp.bottom).offset(0)
            make.right.equalToSuperview().offset(0)
            make.height.equalTo(0.5)
        }
        
        companyCodeTF.placeholder = "请输入社会信用代码（选填）"
        companyCodeTF.font = UIFont.boldSystemFont(ofSize: 16)
        companyCodeTF.setPlaceholderColor(.gray)
        companyCodeTF.textColor = .white
        view.addSubview(companyCodeTF)
        companyCodeTF.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(line1.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
        
        let line2 = UIView()
        line2.backgroundColor = UIColor.init(hexString: "#666666")
        view.addSubview(line2)
        line2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(companyCodeTF.snp.bottom).offset(0)
            make.right.equalToSuperview().offset(0)
            make.height.equalTo(0.5)
        }
        
        nameTF.placeholder = "请输入联系人姓名（必填）"
        nameTF.font = UIFont.boldSystemFont(ofSize: 16)
        nameTF.setPlaceholderColor(.gray)
        nameTF.textColor = .white
        view.addSubview(nameTF)
        nameTF.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(line2.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
        
        let line3 = UIView()
        line3.backgroundColor = UIColor.init(hexString: "#666666")
        view.addSubview(line3)
        line3.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(nameTF.snp.bottom).offset(0)
            make.right.equalToSuperview().offset(0)
            make.height.equalTo(0.5)
        }
        
        phoneTF.placeholder = "请输入联系电话（必填）"
        phoneTF.font = UIFont.boldSystemFont(ofSize: 16)
        phoneTF.setPlaceholderColor(.gray)
        phoneTF.textColor = .white
        view.addSubview(phoneTF)
        phoneTF.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(line3.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
        
        let line4 = UIView()
        line4.backgroundColor = UIColor.init(hexString: "#666666")
        view.addSubview(line4)
        line4.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(phoneTF.snp.bottom).offset(0)
            make.right.equalToSuperview().offset(0)
            make.height.equalTo(0.5)
        }
        
        let codeBtn = UIButton.init(type: .custom)
        codeBtn.setTitle("提交", for: .normal)
        codeBtn.setTitleColor(.white, for: .normal)
        codeBtn.layer.cornerRadius = 6
        codeBtn.layer.masksToBounds = true
        codeBtn.backgroundColor = .mainBlueColor
        codeBtn.addTarget(self, action: #selector(commitAction), for: .touchUpInside)
        view.addSubview(codeBtn)
        codeBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(48)
            make.top.equalTo(line4.snp.bottom).offset(35)
        }

    }
    
    
    @objc func commitAction() {
        
        guard let companyName = companyNameTF.text, !companyName.isEmpty else {
            HUDHelper.showToast("请输入企业名")
            return
        }
        
        guard let name = nameTF.text, !name.isEmpty else {
            HUDHelper.showToast("请输入名字")
            return
        }
        
        guard let phone = phoneTF.text, !phone.isEmpty else {
            HUDHelper.showToast("请输入联系人电话")
            return
        }
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
}
