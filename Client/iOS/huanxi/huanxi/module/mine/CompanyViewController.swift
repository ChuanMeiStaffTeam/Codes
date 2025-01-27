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
        
        companyNameTF.placeholder = "请输入企业名称*"
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
        
        companyCodeTF.placeholder = "请输入社会信用代码"
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
        
        nameTF.placeholder = "请输入联系人姓名*"
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
        
        phoneTF.placeholder = "请输入联系电话*"
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

/*代码功能
 
 显示标题 “企业信息”
 提示用户输入企业名称、社会信用代码、联系人姓名、联系电话
 输入框都带有占位符提示
 点击 “提交” 按钮后会进行一些列的检查
 检查企业名称是否为空
 检查联系人姓名是否为空
 检查联系电话是否为空
 如果通过检查，则会调用 popToRootViewController 方法返回根控制器
 代码优缺点

 优点：

 界面简洁清晰，用户易于理解
 输入框都带有占位符提示，方便用户输入
 对用户输入做了基本的检查
 缺点：

 缺少输入格式的校验，比如社会信用代码的格式
 没有实现提交功能，点击提交后只是返回根控制器
 按钮文本为“提交”，但实际功能并不一定是提交
 没有错误提示，比如输入的社会信用代码格式不正确
 改进建议

 添加正则表达式校验社会信用代码的格式
 实现真正的提交功能，比如提交数据到后端服务器
 根据实际功能修改按钮文本，比如改为“注册”
 添加错误提示，告知用户输入格式不正确等信息
 总而言之，这段代码实现了一个基本的企业信息输入界面。通过改进，可以实现更完善的企业信息收集功能。*/
