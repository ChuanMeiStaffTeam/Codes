//
//  PrivacyviewController.swift
//  huanxi
//
//  Created by rslz on 2024/11/17.
//

import UIKit
import SnapKit

class PrivacyPopupViewController: UIViewController {
    var onAgreeTap: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.bounds = CGRect.init(
            x: 0, y: 0, width: screenWidth - 50, height: 250)

        let titleLabel = UILabel()
        titleLabel.text = "Privacy Policy"
        titleLabel.font = .boldSystemFont(ofSize: 18)

        let messageLabel = UILabel()
        messageLabel.text = "We value your privacy. Please accept our Privacy Policy to proceed."
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        let acceptButton = UIButton(type: .system)
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)

        let declineButton = UIButton(type: .system)
        declineButton.setTitle("Decline", for: .normal)
        declineButton.addTarget(self, action: #selector(declineTapped), for: .touchUpInside)

        // 将子视图添加到父视图
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        view.addSubview(acceptButton)
        view.addSubview(declineButton)


        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalTo(view)
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
        }

        acceptButton.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-16)
            make.trailing.equalTo(view).offset(-16)
        }

        declineButton.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-16)
            make.leading.equalTo(view).offset(16)
        }
    }

    @objc func acceptTapped() {

        dismiss(animated: false) {
            DispatchQueue.global().asyncAfter(deadline: .now() + .microseconds(200)) {
                DispatchQueue.main.async {
                    if let block = self.onAgreeTap {
                          block()
                    }
                }
            }
        }
    }

    @objc func declineTapped() {
        // 处理拒绝逻辑
        exit(0)
    }
}
