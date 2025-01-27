//
//  BindPhoneViewController.swift
//  huanxi
//
//  Created by jack on 2024/9/12.
//

import UIKit

class BindPhoneViewController: BaseViewController {
    
    let textField = UITextField()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

/*功能

这段代码实现了一个绑定手机号码的界面，叫做 BindPhoneViewController。 用户可以通过该界面输入手机号码，然后获取验证码进行验证，从而完成绑定手机号码的操作。

代码结构

类:
BindPhoneViewController: 用于绑定手机号码的界面控制器。
属性:
textField: 用户输入手机号码的文本框。
方法:
viewDidLoad: 初始化界面，加载界面元素并设置约束。
setupView: 设置界面的标题、文本框和其他元素的样式。
requestCode: 处理“获取验证码”按钮点击事件，并进行手机号码格式验证。
代码逻辑

在 viewDidLoad 方法中，调用 setupView 方法来设置界面的各个元素。
setupView 方法负责创建并配置界面元素：
设置标题为 "绑定手机"。
创建标签解释绑定手机号码的目的。
配置 textField 文本框，用于用户输入手机号码。
创建一个按钮 "获取验证码" (codeBtn)。
点击 “获取验证码” 按钮 (codeBtn) 会触发 requestCode 方法：
检查输入的手机号码是否为 11 位数字，如果不是则使用 HUDHelper.showToast 提示用户输入正确的手机号。
如果手机号码格式正确，则会新建一个 InputCodeViewController 控制器 (おそらく验证码输入界面)，并将当前输入的手机号码传递给该控制器，然后通过导航控制器 (navigationController) 推送到下一个界面。
 总体而言，这段代码的功能是让用户通过输入手机号码并获取验证码的方式来完成绑定手机的过程。*/
