//
//  LoginViewController.swift
//  huanxi
//
//  Created by jack on 2024/7/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {

    private let iconImgView = UIImageView().then({view in
        view.image = UIImage.init(named: "huanxi.jpg")
    })
    
    private let tipLabel = UILabel().then({ view in
        view.text = "未注册的手机号登录成功后将自动注册"
        view.textColor = UIColor.white_60
        view.font = UIFont.systemFont(ofSize: 12)
    })
    
    private let closeBtn = UIButton().then({view in
        view.setImage(UIImage.init(named: "publish_close"), for: .normal)
    })
    
    private let phoneTextField = UITextField().then({view in
        view.placeholder = "请输入手机号"
        view.borderStyle = .roundedRect
        view.keyboardType = .numberPad
    })
    private let codeTextField = UITextField().then({view in
        view.placeholder = "请输入验证码"
        view.borderStyle = .roundedRect
        view.keyboardType = .numberPad
    })
    private let verifyButton = UIButton().then({view in
        view.setTitle("获取验证码", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.isEnabled = false
    })
    private let codeStackView = UIStackView().then({view in
    })
    private let agreementCheckbox = UIButton().then({view in
        view.setTitle("☐", for: .normal)
        view.setTitle("☑", for: .selected)
        view.setTitleColor(.white, for: .normal)
        view.setTitleColor(.white, for: .selected)
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0)
        view.configuration = config
    })
    private let agreementLabel = RichTextLabel().then({view in
        let message = "我已阅读并同意《用户协议》《隐私协议》"
        view.text = message
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 14)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.white
        ]
        let userTitle = NSLocalizedString("protocol_user_title", comment: "")
        let privacyTitle = NSLocalizedString("protocol_privacy_title", comment: "")
        let tapStyles: [(String, UIColor)] = [
            (userTitle, UIColor.linkColor),
            (privacyTitle, UIColor.linkColor)
        ]
        view.setRichText(message, attributes: attributes, tapStyles: tapStyles)
    })
    private let loginButton = UIButton().then({view in
        view.setTitle("验证并登录", for: .normal)
        view.backgroundColor = .mainBlueColor.withAlphaComponent(0.5)
        view.layer.cornerRadius = 6
        view.isEnabled = false
    })

    private let countdownTime = BehaviorRelay<Int>(value: 60)
    private let isAgreementChecked = BehaviorRelay<Bool>(value: false)
    private let isPhoneNumberValid = BehaviorRelay<Bool>(value: false)
    private let isCodeTextFieldVisible = BehaviorRelay<Bool>(value: false)
    private let isCodeValid = BehaviorRelay<Bool>(value: false)
    
    // 用于存储登录结果的 continuation
    private var loginContinuation: CheckedContinuation<Bool, Never>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(CGFloat.topSafeAreaHeight + 10)
            make.width.height.equalTo(30)
        }

        
        view.addSubview(iconImgView)
        iconImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(CGFloat.topSafeAreaHeight + 135)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImgView.snp.bottom).offset(10)
        }
        
        [codeTextField, verifyButton].forEach{ codeStackView.addArrangedSubview($0) }
        codeStackView.axis = .horizontal
        codeStackView.spacing = 10
        codeStackView.distribution = .fillProportionally

        let agreementStackView = UIStackView(arrangedSubviews: [agreementCheckbox, agreementLabel])
        agreementStackView.axis = .horizontal
        agreementStackView.spacing = 0
        agreementStackView.alignment = .center

        let mainStackView = UIStackView(arrangedSubviews: [phoneTextField, codeStackView, loginButton, agreementStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.alignment = .fill
        view.addSubview(mainStackView)

        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(tipLabel.snp.bottom).offset(45)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }

        codeTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }

        verifyButton.snp.makeConstraints { make in
            make.width.equalTo(120)
        }

        loginButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }

        agreementCheckbox.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
    }

    private func setupBindings() {
        
        closeBtn.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.loginContinuation?.resume(returning: false)
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        phoneTextField.rx.text.orEmpty
            .map { $0.count == 11 }
            .bind(to: isPhoneNumberValid)
            .disposed(by: disposeBag)

        isPhoneNumberValid
            .bind(to: verifyButton.rx.isEnabled)
            .disposed(by: disposeBag)

        codeTextField.rx.text.orEmpty
            .map { $0.count >= 4 }
            .bind(to: isCodeValid)
            .disposed(by: disposeBag)
        
        verifyButton.rx.tap
            .bind { [weak self] in
                self?.startCountdown()
            }
            .disposed(by: disposeBag)
        
        isCodeTextFieldVisible
            .subscribe(onNext: { [weak self] visible in
                guard let `self` = self else { return }
                loginButton.setTitle(visible ? "登录" : "验证并登录", for: .normal)
                codeStackView.isHidden = !visible
                if visible {
                    self.startCountdown()
                }
            })
            .disposed(by: disposeBag)

        countdownTime
            .map { $0 > 0 ? "\($0)s 后重新获取" : "重新发送" }
            .bind(to: verifyButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

        countdownTime
            .map { $0 == 0 }
            .bind(to: verifyButton.rx.isEnabled)
            .disposed(by: disposeBag)

        agreementCheckbox.rx.tap
            .map { !self.isAgreementChecked.value }
            .bind(to: isAgreementChecked)
            .disposed(by: disposeBag)

        isAgreementChecked
            .bind(to: agreementCheckbox.rx.isSelected)
            .disposed(by: disposeBag)
        
        agreementLabel.onTextTapped = { [weak self] string, range, index in
            guard let `self` = self else { return }
            print("点击了: \(string), 范围: \(range), 索引: \(index)")
            let docxName = string.contains("用户协议") ? "欢喜用户协议" : "欢喜隐私协议"
            let filePath = Bundle.main.path(forResource: docxName, ofType: "docx") ?? ""
            DocumentPreviewer.shared.show(from: self, filePaths: [filePath]) {
                print("文件预览完成")
            }
        }

        Observable.combineLatest(isPhoneNumberValid, isCodeTextFieldVisible, isCodeValid)
            .map { isValid, isVisible, isCodeValid in
                isVisible ? (isValid && isCodeValid) : isValid
            }
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        Observable.combineLatest(
            isPhoneNumberValid,
            isCodeTextFieldVisible,
            codeTextField.rx.text.orEmpty.map { $0.count >= 4 }
        )
        .map { phoneValid, codeVisible, codeValid in
            (codeVisible && codeValid) || (!codeVisible && phoneValid)
        }
        .map { $0 ? .mainBlueColor : .mainBlueColor.withAlphaComponent(0.5) }
        .bind(to: loginButton.rx.backgroundColor)
        .disposed(by: disposeBag)

        loginButton.rx.tap
            .bind { [weak self] in
                guard let `self` = self else { return }
                if self.isCodeTextFieldVisible.value {
                    if self.isAgreementChecked.value {
                        // 处理登录逻辑
                        self.loginAction()
                    } else {
                        // 提示用户同意隐私协议
                        HUDHelper.showToast("请阅读并同意《用户协议》《隐私政策》")
                    }
                } else {
                    Task {
                        let success = await LoginManager.requestCode(self.phoneTextField.text ?? "")
                        if success {
                            self.isCodeTextFieldVisible.accept(true)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }


    private func startCountdown() {
        countdownTime.accept(60)
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .take(60)
            .map { 60 - $0 - 1 }
            .bind(to: countdownTime)
            .disposed(by: disposeBag)
    }
    
    
    private func loginAction() {
        guard let account = phoneTextField.text, !account.isEmpty else { return }
        guard let code = codeTextField.text, !code.isEmpty else { return }
        let params = [
            "phone": account,
            "code": code
        ]
        LoginManager.requestLogin(params: params) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.onBackTap()
                self.loginContinuation?.resume(returning: true)
            } else {
                self.loginContinuation?.resume(returning: false)
            }
        }
    }
    
    /// 异步方法，外部调用此方法以等待登录结果
    static func startLogin() async -> Bool {
        await withCheckedContinuation { continuation in
            let loginVC = LoginViewController()
            loginVC.loginContinuation = continuation
            loginVC.modalPresentationStyle = .fullScreen

            // 确保 UI 在主线程上操作
            DispatchQueue.main.async {
                let topVC = WindowHelper.topViewController()
                topVC?.present(loginVC, animated: true)
            }
        }
    }
}
