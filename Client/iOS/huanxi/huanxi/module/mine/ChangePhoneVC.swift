//
//  ChangePhoneVC.swift
//  huanxi
//
//  Created by rslz on 2025/1/10.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class ChangePhoneVC: BaseViewController {
    private let titleLabel = UILabel().then({ view in
        view.text = "更换手机号"
        view.textColor = .white
        view.font = UIFont.boldSystemFont(ofSize: 24)
    })
    private let phoneTextField = UITextField().then({ view in
        view.placeholder = "请输入手机号"
        view.borderStyle = .roundedRect
        view.keyboardType = .numberPad
    })
    private let codeTextField = UITextField().then({ view in
        view.placeholder = "请输入验证码"
        view.borderStyle = .roundedRect
        view.keyboardType = .numberPad
    })
    private let verifyButton = UIButton().then({ view in
        view.setTitle("获取验证码", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.isEnabled = false
    })
    private let codeStackView = UIStackView().then({ _ in
    })

    private let confirmButton = UIButton().then({ view in
        view.setTitle("获取验证码", for: .normal)
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 6
        view.isEnabled = false
    })

    private let countdownTime = BehaviorRelay<Int>(value: 60)
    private let isPhoneNumberValid = BehaviorRelay<Bool>(value: false)
    private let isCodeTextFieldVisible = BehaviorRelay<Bool>(value: false)
    private let isCodeValid = BehaviorRelay<Bool>(value: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(CGFloat.topBarHeight + 20)
            make.height.equalTo(50)
        }

        [codeTextField, verifyButton].forEach { codeStackView.addArrangedSubview($0) }
        codeStackView.axis = .horizontal
        codeStackView.spacing = 10
        codeStackView.distribution = .fillProportionally

        let mainStackView = UIStackView(arrangedSubviews: [phoneTextField, codeStackView, confirmButton])
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.alignment = .fill
        view.addSubview(mainStackView)

        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
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

        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }

    private func setupBindings() {
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
                confirmButton.setTitle(visible ? "更换" : "获取验证码", for: .normal)
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

        Observable.combineLatest(isPhoneNumberValid, isCodeTextFieldVisible, isCodeValid)
            .map { isValid, isVisible, isCodeValid in
                isVisible ? (isValid && isCodeValid) : isValid
            }
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)

        Observable.combineLatest(
            isPhoneNumberValid,
            isCodeTextFieldVisible,
            codeTextField.rx.text.orEmpty.map { $0.count >= 4 }
        )
        .map { phoneValid, codeVisible, codeValid in
            (codeVisible && codeValid) || (!codeVisible && phoneValid)
        }
        .map { $0 ? .mainBlueColor : UIColor.lightGray }
        .bind(to: confirmButton.rx.backgroundColor)
        .disposed(by: disposeBag)

        confirmButton.rx.tap
            .bind { [weak self] in
                guard let `self` = self else { return }
                if self.isCodeTextFieldVisible.value {
                    self.changePhone()
                } else {
                    Task {
                        let success = await LoginManager.fetchUpdatePhoneCode(self.phoneTextField.text ?? "")
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

    private func changePhone() {
        guard let account = phoneTextField.text, !account.isEmpty else { return }
        guard let code = codeTextField.text, !code.isEmpty else { return }
        let params = [
            "phone": account,
            "code": code,
        ]
        Task {
            let success = await LoginManager.requestChangePhone(params)
            if success {
                HUDHelper.showToast("手机号更换成功")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.onBackTap()
                })
            }
        }
    }
}


/*代码功能：
 
 这段代码实现了一个用于更换手机号码的视图控制器。用户可以通过这个界面输入新的手机号码，获取验证码，并完成手机号的更换。

 代码结构：

 类: ChangePhoneVC
 负责管理更换手机号码的界面和逻辑。
 属性:
 titleLabel: 显示“更换手机号”标题的标签。
 phoneTextField: 用于输入新手机号码的文本框。
 codeTextField: 用于输入验证码的文本框。
 verifyButton: 获取验证码按钮。
 confirmButton: 确认更换按钮。
 countdownTime: 用于控制验证码倒计时的时间。
 isPhoneNumberValid: 用于判断输入的手机号是否有效。
 isCodeTextFieldVisible: 用于控制验证码输入框的显示与隐藏。
 isCodeValid: 用于判断输入的验证码是否有效。
 方法:
 setupUI: 初始化界面，设置各个控件的布局和样式。
 setupBindings: 使用 RxSwift 绑定各个控件的状态和事件，实现响应式的用户交互。
 startCountdown: 开始验证码倒计时。
 changePhone: 发送请求，将新的手机号和验证码提交到服务器进行验证并更新用户信息。
 代码逻辑:

 界面初始化:
 在 viewDidLoad 方法中调用 setupUI 方法，创建并布局界面上的各个元素。
 数据绑定:
 使用 RxSwift 绑定文本框的输入内容、按钮的状态和倒计时等，实现实时更新和交互。
 当用户输入手机号码时，判断其是否有效，并根据有效性启用或禁用“获取验证码”按钮。
 当用户点击“获取验证码”按钮时，开始倒计时，并发送请求获取验证码。
 当用户输入验证码后，判断验证码是否有效，并启用“确认”按钮。
 点击“确认”按钮时，将新的手机号和验证码发送到服务器进行验证，并更新用户信息。
 核心功能:

 输入手机号码: 用户在文本框中输入新的手机号码。
 获取验证码: 点击“获取验证码”按钮后，系统会向用户输入的手机号发送验证码。
 输入验证码: 用户在验证码文本框中输入收到的验证码。
 确认更换: 点击“确认”按钮，系统会将新的手机号和验证码发送到服务器进行验证，如果验证通过，则更新用户的手机号码。
 代码亮点:

 使用 RxSwift: 采用响应式编程的方式，使得代码更加简洁、易于维护。
 状态管理: 使用 BehaviorRelay 来管理各种状态，例如验证码倒计时、手机号是否有效等。
 用户交互: 提供了流畅的用户体验，实时反馈用户输入。
 错误处理: 可以通过添加错误处理机制来提高代码的健壮性。
 总结:

 这段代码通过巧妙地利用 RxSwift，实现了用户更换手机号码的功能。它具有良好的用户体验，并且代码结构清晰，易于维护。*/
