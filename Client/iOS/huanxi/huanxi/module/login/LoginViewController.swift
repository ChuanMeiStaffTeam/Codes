//
//  LoginViewController.swift
//  huanxi
//
//  Created by jack on 2024/7/24.
//

import UIKit

class LoginViewController: BaseViewController {
    let closeBtn = UIButton.init(type: .custom)
    let accountTF = UITextField()
    let pwdTF = UITextField()

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
            make.top.equalTo(accountTF.snp.bottom).offset(16)
        }
        
        let loginBtn = UIButton.init(type: .custom)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.backgroundColor = .mainBlueColor
        loginBtn.layer.cornerRadius = 6
        loginBtn.layer.masksToBounds = true
        loginBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        loginBtn.setTitle("登录", for: .normal)
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(pwdTF.snp.bottom).offset(24)
        }
        
        let registerLabel = UILabel()
        registerLabel.text = "还没有账号？"
        registerLabel.textColor = .white
        registerLabel.font = .systemFont(ofSize: 14)
        view.addSubview(registerLabel)
        registerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-CGFloat.bottomSafeAreaHeight - 30)
        }
        
        let registerBtn = UIButton.init(type: .custom)
        registerBtn.setTitleColor(.mainBlueColor, for: .normal)
        registerBtn.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        registerBtn.setTitle("注册", for: .normal)
        registerBtn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        view.addSubview(registerBtn)
        registerBtn.snp.makeConstraints { make in
            make.centerY.equalTo(registerLabel).offset(0)
            make.left.equalTo(registerLabel.snp.right).offset(5)
            make.height.equalTo(32)
        }
        
        
    }
    
    
    @objc func closeAction() {
        self.dismiss(animated: true)
    }
    
    @objc func registerAction() {
        let vc = RegisterViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(RegisterViewController(), animated: true)
        
    }
    
    @objc func loginAction() {
        guard let account = accountTF.text, !account.isEmpty else {
            HUDHelper.showToast("请输入账号")
            return
        }
        
        guard let pwd = pwdTF.text, !pwd.isEmpty else {
            HUDHelper.showToast("请输入密码")
            return
        }
        

        let params = [
            "username": account,
            "password": pwd
        ]
        
        NetworkManager.shared.postRequest(urlStr: "user/login/username",
                                          parameters: params,
                                          responseType: LoginModel.self) { success, message, data in
            if success {
                if let token = data?.token {
                    LoginManager.updateToken(token: token)
                    
                    let tabbar = TabBarController()
                    WindowHelper.currentWindow()?.rootViewController = tabbar
                }
                if let userInfo = data?.userinfo {
//                    UserDefaults.standard.set(userInfo, forKey: "userInfo")
//                    UserDefaults.standard.synchronize()
                }
            }
            HUDHelper.showToast(message)
        }
    }
    
}
