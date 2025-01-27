//
//  InputCodeViewController.swift
//  huanxi
//
//  Created by jack on 2024/9/12.
//

import UIKit
import SwiftUI

class InputCodeViewController: BaseViewController {
    
    var phoneNumber: String?
    
    let textField = UITextField()
    
    // 定时器
    private var timer: Timer?
    private var time = 60
    let reCodeBtn = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        startTimer()
    }
    
    func setupView() {
        
        let titleLabel = UILabel()
        titleLabel.text = "输入手机验证码"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(CGFloat.topBarHeight+20)
        }
        
        let descLabel = UILabel()
        descLabel.text = "验证码已发送至 86-" + (phoneNumber ?? "")
        descLabel.textColor = .white
        descLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        textField.placeholder = "请输入验证码"
        textField.font = UIFont.boldSystemFont(ofSize: 16)
        textField.setPlaceholderColor(.gray)
        textField.textColor = .white
        textField.layer.cornerRadius = 6
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.75
        textField.layer.borderColor = UIColor.init(hexString: "#999999").cgColor
        let leftView = UIView(frame: CGRect.init(x: 0, y: 0, width: 20, height: 48))
        textField.leftView = leftView
        textField.leftViewMode = .always
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(descLabel.snp.bottom).offset(35)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
        
        reCodeBtn.setTitleColor(.white, for: .normal)
        reCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(reCodeBtn)
        reCodeBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.top.equalTo(textField.snp.bottom).offset(25)
        }
        
        let codeBtn = UIButton.init(type: .custom)
        codeBtn.setTitle("绑定", for: .normal)
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
            make.top.equalTo(reCodeBtn.snp.bottom).offset(35)
        }
        

    }
    
    @objc func timeUpdate() {
        
        if time <= 0 {
            stopTimer()
            time = 60
            reCodeBtn.setTitle("重新获取验证码", for: .normal)
            reCodeBtn.isEnabled = true
            reCodeBtn.setTitleColor(.white, for: .normal)
        } else {
            reCodeBtn.setTitle("重新获取验证码（" + String(time) + "）", for: .normal)
            reCodeBtn.isEnabled = false
            reCodeBtn.setTitleColor(.gray, for: .normal)
            time -= 1
        }
    }
    
    // 启动定时器
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
    }
    
    // 停止定时器
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // 移除定时器
    deinit {
        stopTimer()
    }
    
    @objc func requestCode() {
        if self.textField.text?.count != 4 {
            HUDHelper.showToast("请输入正确的验证码")
            return
        }
        HUDHelper.showToast("绑定成功")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}


/*这段代码用 Swift 语言编写了一个名为 InputCodeViewController 的视图控制器，用于用户输入手机收到的验证码。下面是它的功能细分：
 
 元素:

 titleLabel： 显示 "输入手机验证码" 的标签。
 descLabel： 显示 "验证码已发送至 86-" 加上用户手机号（外部提供）的标签。
 textField： 用户输入验证码的文本框。
 reCodeBtn (重新获取验证码按钮)： 初始禁用，显示请求新验证码的倒计时时间的按钮。
 codeBtn (绑定按钮)： 用于提交验证码的按钮。
 功能:

 界面设置:
 布局界面元素，包括标签、文本框和按钮。
 计时器:
 在视图出现时启动一个 60 秒的倒计时器。
 更新 reCodeBtn 的标题以显示剩余时间，或者在计时器结束时显示 "重新获取验证码"。
 当计时器归零时启用 reCodeBtn。
 用户交互:
 点击 reCodeBtn (启用时) 可能触发一个请求新验证码的操作（这里未实现）。
 点击 codeBtn 会校验验证码 (检查是否是 4 位数字)：
 如果无效，则显示吐司消息 "请输入正确的验证码"。
 如果有效，则显示吐司消息 "绑定成功" 并导航回根视图控制器。
 总体而言，这个视图控制器用于处理用户在账户绑定或其他验证流程中，输入发送到手机的验证码的过程。
*/
