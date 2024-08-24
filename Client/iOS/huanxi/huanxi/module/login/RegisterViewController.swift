//
//  RegisterViewController.swift
//  huanxi
//
//  Created by jack on 2024/7/24.
//

import UIKit

class RegisterViewController: BaseViewController {
    let closeBtn = UIButton.init(type: .custom)
    let accountTF = UITextField()
    let nickNameTF = UITextField()
    let pwdTF = UITextField()
    let repwdTF = UITextField()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        
        closeBtn.setImage(UIImage.init(named: "publish_close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(CGFloat.topSafeAreaHeight + 10)
            make.width.height.equalTo(30)
        }
        
        let iconImgView = UIImageView()
        iconImgView.image = UIImage.init(named: "instagram")
        view.addSubview(iconImgView)
        iconImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(CGFloat.topSafeAreaHeight + 150)
            make.height.equalTo(50)
        }
        
        accountTF.placeholder = "账号"
        accountTF.layer.cornerRadius = 6
        accountTF.layer.masksToBounds = true
        accountTF.layer.borderWidth = 0.5
        accountTF.textColor = .white
        accountTF.layer.borderColor = UIColor.lightGray.cgColor
        accountTF.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 12, height: 40))
        accountTF.leftViewMode = .always
        accountTF.setPlaceholderColor(.lightGray)
        view.addSubview(accountTF)
        accountTF.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(40)
            make.top.equalTo(iconImgView.snp.bottom).offset(49)
        }
        
        nickNameTF.placeholder = "昵称"
        nickNameTF.layer.cornerRadius = 6
        nickNameTF.layer.masksToBounds = true
        nickNameTF.layer.borderWidth = 0.5
        nickNameTF.textColor = .white
        nickNameTF.layer.borderColor = UIColor.lightGray.cgColor
        nickNameTF.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 12, height: 40))
        nickNameTF.leftViewMode = .always
        nickNameTF.setPlaceholderColor(.lightGray)
        view.addSubview(nickNameTF)
        nickNameTF.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(40)
            make.top.equalTo(accountTF.snp.bottom).offset(16)
        }
        
        pwdTF.placeholder = "密码"
        pwdTF.layer.cornerRadius = 6
        pwdTF.layer.masksToBounds = true
        pwdTF.layer.borderWidth = 0.5
        pwdTF.textColor = .white
        pwdTF.isSecureTextEntry = true
        pwdTF.layer.borderColor = UIColor.lightGray.cgColor
        pwdTF.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 12, height: 40))
        pwdTF.leftViewMode = .always
        pwdTF.setPlaceholderColor(.lightGray)
        view.addSubview(pwdTF)
        pwdTF.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(40)
            make.top.equalTo(nickNameTF.snp.bottom).offset(16)
        }
        
        repwdTF.placeholder = "确认密码"
        repwdTF.layer.cornerRadius = 6
        repwdTF.layer.masksToBounds = true
        repwdTF.layer.borderWidth = 0.5
        repwdTF.textColor = .white
        repwdTF.isSecureTextEntry = true
        repwdTF.layer.borderColor = UIColor.lightGray.cgColor
        repwdTF.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 12, height: 40))
        repwdTF.leftViewMode = .always
        repwdTF.setPlaceholderColor(.lightGray)
        view.addSubview(repwdTF)
        repwdTF.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(40)
            make.top.equalTo(pwdTF.snp.bottom).offset(16)
        }
        
        let registerBtn = UIButton.init(type: .custom)
        registerBtn.setTitleColor(.white, for: .normal)
        registerBtn.backgroundColor = .mainBlueColor
        registerBtn.layer.cornerRadius = 6
        registerBtn.layer.masksToBounds = true
        registerBtn.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        registerBtn.setTitle("登录", for: .normal)
        view.addSubview(registerBtn)
        registerBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(repwdTF.snp.bottom).offset(24)
        }
        
    }
    
    
    @objc func closeAction() {
        self.dismiss(animated: true)
    }
    
    @objc func registerAction() {
        guard let account = accountTF.text, !account.isEmpty else {
            HUDHelper.showToast("请输入账号")
            return
        }
        
        guard let nickname = nickNameTF.text, !nickname.isEmpty else {
            HUDHelper.showToast("请输入用户名")
            return
        }
        
        guard let pwd = pwdTF.text, !pwd.isEmpty else {
            HUDHelper.showToast("请输入密码")
            return
        }
        
        guard let repwd = repwdTF.text, !repwd.isEmpty else {
            HUDHelper.showToast("请再次输入密码")
            return
        }
        
        guard pwd == repwd else {
            HUDHelper.showToast("两次密码输入不一致")
            return
        }

        let params = [
            "username": account,
            "fullName": nickname,
            "password": pwd,
            "password2": pwd
        ]
        
        NetworkManager.shared.postRequest(urlStr: "user/register/username",
                                          parameters: params,
                                          responseType: String.self) { success, message, data in
            if success {
                self.dismiss(animated: true)
            }
            HUDHelper.showToast(message)
        }
    }
    
}
