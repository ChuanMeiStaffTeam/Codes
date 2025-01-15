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
