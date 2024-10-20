//
//  BindPhoneViewController.swift
//  huanxi
//
//  Created by jack on 2024/9/12.
//

import UIKit
import SwiftUI

class BindPhoneViewController: BaseViewController {
    
    let textField = UITextField()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        title = "绑定手机"
        
        let titleLabel = UILabel()
        titleLabel.text = "绑定手机号"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(CGFloat.topBarHeight+20)
        }
        
        let descLabel = UILabel()
        descLabel.text = "绑定后即可通过手机号登录"
        descLabel.textColor = .white
        descLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        textField.placeholder = "请输入手机号码"
        textField.font = UIFont.boldSystemFont(ofSize: 16)
        textField.setPlaceholderColor(.gray)
        textField.textColor = .white
        textField.layer.cornerRadius = 6
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.75
        textField.layer.borderColor = UIColor.init(hexString: "#999999").cgColor
        
        let leftView = UIView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 48))
        let leftLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: 50, height: 48))
        leftLabel.text = "86"
        leftLabel.textColor = .white
        leftLabel.textAlignment  = .center
        leftLabel.font = UIFont.boldSystemFont(ofSize: 16)
        leftView.addSubview(leftLabel)
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(descLabel.snp.bottom).offset(35)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
        
        let codeBtn = UIButton.init(type: .custom)
        codeBtn.setTitle("获取验证码", for: .normal)
        codeBtn.setTitleColor(.white, for: .normal)
        codeBtn.layer.cornerRadius = 6
        codeBtn.layer.masksToBounds = true
        codeBtn.backgroundColor = .mainBlueColor
        codeBtn.addTarget(self, action: #selector(requestCode), for: .touchUpInside)
        view.addSubview(codeBtn)
        codeBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(48)
            make.top.equalTo(textField.snp.bottom).offset(35)
        }
        

    }
    
    @objc func requestCode() {
        
        if self.textField.text?.count != 11 {
            HUDHelper.showToast("请输入正确的手机号")
            return
        }
        
        let vc = InputCodeViewController()
        vc.phoneNumber = self.textField.text
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
