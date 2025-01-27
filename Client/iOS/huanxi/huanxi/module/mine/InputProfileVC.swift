//
//  InputProfileVC.swift
//  huanxi
//
//  Created by rslz on 2025/1/15.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class InputProfileVC: BaseViewController {

    lazy var textField: UITextField = {
        let view = UITextField.init(frame: CGRect.zero)
        view.setPlaceholderColor(.lightGray)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .init(hex: 0x171717)
        view.returnKeyType = .send
        view.textColor = .white
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.leftView = UIView(frame: CGRect.init(x: 0, y: 0, width: 12, height: 32))
        view.leftViewMode = .always
        return view
    }()
    
    private let charCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("  确认  ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.isEnabled = false
        button.setTitleColor(UIColor.white_80, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        return button
    }()
    
    var initialText: String = "" // 上一页面传入的文本
    
    var type: MineViewModel.ProfileType = .name

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
    }
    
    private func setupUI() {
        
        self.title = "编辑" + type.title
        let rightItem = UIBarButtonItem(customView: confirmButton)
        self.navigationItem.rightBarButtonItem = rightItem
        
        charCountLabel.text = "1/\(type.limit)"
        
        textField.placeholder = "请输入" + type.title

        view.addSubview(textField)
        view.addSubview(charCountLabel)
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(44)
            make.right.equalToSuperview().offset(-20)
        }
        charCountLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.right.equalTo(textField.snp.right)
        }
    }
    
    private func bindUI() {
        // 设置初始值
        textField.text = initialText
        
        // 监听TextField的输入
        let textObservable = textField.rx.text.orEmpty.share(replay: 1)
        
        // 字符数量限制
        textObservable
            .map { text in
                let limitedText = String(text.prefix(self.type.limit))
                self.textField.text = limitedText // 如果超出限制，自动修正输入
                return "\(limitedText.count)/\(self.type.limit)"
            }
            .bind(to: charCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 限制输入字符数为2到24
        textObservable
            .map { $0.count >= 1 && $0.count <= self.type.limit }
            .bind { [weak self] isValid in
                guard let `self` = self else { return }
                if !isValid, let text = self.textField.text {
                    let trimmedText = String(text.prefix(self.type.limit))
                    self.textField.text = trimmedText
                }
            }
            .disposed(by: disposeBag)
        
        // 确认按钮状态
        textObservable
            .map { [weak self] in $0 != self?.initialText && $0.count >= 1 && $0.count <= (self?.type.limit)! }
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 按钮置灰效果
        textObservable
            .map { [weak self] in
                ($0 != self?.initialText && $0.count >= 2 && $0.count <= 24) ? .mainBlueColor : UIColor.darkGray
            }
            .bind(to: confirmButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        
        confirmButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            
            let params = [
                self.type.key: self.textField.text ?? "",
            ]
            
            Task{
                HUDHelper.showHUD(self.view, text: "")
                let success = await LoginManager.fetchUpdateUserInfo(params: params)
                HUDHelper.hideHUD(self.view)
                if success {
                    HUDHelper.showToast("修改成功")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.onBackTap()
                    }
                }
            }
   
        }).disposed(by: disposeBag)
    }
}

/*功能
 
 这段代码实现了一个编辑用户资料的界面，用户可以在此界面修改其特定类型的个人信息。 它是用来配合上一个界面（比如编辑资料界面）使用的，用来更详细地编辑某个字段。

 代码结构

 类:
 InputProfileVC: 编辑资料的视图控制器，负责界面的搭建、数据绑定和用户交互处理。
 属性:
 textField: 用户输入资料的文本框。
 charCountLabel: 显示文本框字符数的标签。
 confirmButton: 确认修改资料的按钮。
 initialText: 上一页面传过来的初始文本内容。
 type: 一个枚举值，表示当前编辑的资料类型（例如名字、用户名、网站、个性签名）。
 方法:
 viewDidLoad: 设置界面的标题和布局，并绑定数据。
 setupUI: 设置界面的各个控件的属性和位置。
 bindUI: 绑定输入框的文本变化和其他控件的事件。
 代码逻辑

 界面加载时，首先根据 type 设置标题，并根据 initialText 设置文本框的初始值。
 监听文本框的输入内容变化 (textObservable)。
 实时更新字符数标签 (charCountLabel) 的内容。
 限制输入的字符数量 (2 - type.limit 个字符)，并自动截断超出限制的文本。
 根据输入内容是否有效 (非空，字符数满足限制) 启用/禁用确认按钮 (confirmButton)。
 设置确认按钮的背景色以指示其可用状态。
 点击确认按钮 (confirmButton) 时，会触发以下操作：
 准备包含更新用户信息的参数 (params)。
 异步调用 LoginManager.fetchUpdateUserInfo 更新服务器上的用户信息。
 显示/隐藏加载提示框 (HUDHelper)。
 如果更新成功，则会提示修改成功并返回上一个界面。
 总体而言，这段代码通过 RxSwift 实现了响应式的 UI 更新和数据绑定，使界面更易于维护和扩展。
*/
