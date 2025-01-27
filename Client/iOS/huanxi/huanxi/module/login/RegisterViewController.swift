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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sh_prefersNavigationBarHidden = true
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
        iconImgView.image = UIImage.init(named: "huanxi.jpg")
        view.addSubview(iconImgView)
        iconImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(CGFloat.topSafeAreaHeight + 150)
            make.height.equalTo(50)
            make.width.equalTo(100)
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
        
        NetworkManager.shared.postRequest(path: "user/register/username",
                                          parameters: params,
                                          responseType: String.self) { success, message, data in
            if success {
                self.dismiss(animated: true)
            }
            HUDHelper.showToast(message)
        }
    }
    
}

/*代码功能：

这段代码实现了一个用户注册的视图控制器。它主要负责用户输入账号、昵称、密码等信息，并向服务器发送注册请求。

主要功能点：

UI布局: 使用 SnapKit 对各个 UI 元素进行布局，包括文本输入框、按钮等。
数据校验: 在提交注册信息之前，对账号、昵称、密码等字段进行基本的校验，确保输入的有效性。
网络请求: 通过 NetworkManager.shared.postRequest 发送注册请求到服务器，并将服务器返回的结果进行处理。
用户交互: 提供关闭按钮、文本输入框、按钮等交互元素，方便用户进行操作。
代码结构：

类名: RegisterViewController，表示这是一个用于注册的视图控制器。
属性:
closeBtn: 关闭按钮。
accountTF, nickNameTF, pwdTF, repwdTF: 用于输入账号、昵称、密码的文本框。
其他一些用于布局和状态管理的属性。
方法:
viewDidLoad: 在视图加载时，进行 UI 布局和绑定事件。
setupView: 初始化 UI 元素并设置约束。
closeAction: 关闭视图控制器。
registerAction: 处理注册按钮点击事件，验证输入信息并发送网络请求。
代码逻辑:

用户输入: 用户在文本框中输入账号、昵称和密码。
校验: 点击注册按钮时，系统会校验输入信息的合法性，例如密码是否一致等。
网络请求: 如果校验通过，则向服务器发送注册请求。
处理响应: 根据服务器返回的结果，显示相应的提示信息，如注册成功或失败。
潜在改进:

密码强度校验: 可以增加密码强度校验，要求密码包含数字、字母和特殊字符等。
用户协议: 可以增加用户协议勾选框，要求用户同意协议才能注册。
验证码: 可以增加验证码功能，提高安全性。
加载指示: 在发送网络请求时，可以显示加载指示器。
错误处理: 可以对网络请求错误进行更详细的处理，并提示用户。
UI优化: 可以对 UI 进行优化，使其更加美观和用户友好。
*/
