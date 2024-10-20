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
        self.navigationController?.isNavigationBarHidden = false
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
