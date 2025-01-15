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
            .map { "\($0.count)/\(self.type.limit)" }
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
