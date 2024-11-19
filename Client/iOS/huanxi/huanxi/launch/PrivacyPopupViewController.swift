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
            x: 0, y: 0, width: screenWidth - UIDevice.screenWidthScale(50), height: 520)

        let titleLabel = UILabel()
        let title = NSLocalizedString("title_reminder", comment: "")
        titleLabel.text = title
        titleLabel.textColor = UIColor.black
        titleLabel.font = .boldSystemFont(ofSize: 18)

        let messageLabel = RichTextLabel()
        let message = NSLocalizedString("privacy_tips", comment: "")
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 14)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.black
        ]
        
        let userTitle = NSLocalizedString("protocol_user_title", comment: "")
        let privacyTitle = NSLocalizedString("protocol_privacy_title", comment: "")
        let tapStyles: [(String, UIColor)] = [
            (userTitle, UIColor.linkColor),
            (privacyTitle, UIColor.linkColor)
        ]
        messageLabel.setRichText(message, attributes: attributes, tapStyles: tapStyles)
        messageLabel.onTextTapped = { string, range, index in
            print("点击了: \(string), 范围: \(range), 索引: \(index)")
            let protocolStr = NSLocalizedString("protocol_privacy", comment: "")
            let webVC = WebVC()
            webVC.contentStr = protocolStr
            webVC.pageTitle = string
            let nav = NavigationController(rootViewController: webVC)
            self.present(nav, animated: true, completion: nil)
        }
        
    
        let accept = NSLocalizedString("agree_and_continue", comment: "")
        let acceptButton = createButton(
            title: accept, // 替换为实际文本
            backgroundColor: UIColor.black, // 替换为主题颜色
            textColor: UIColor.white,
            action: #selector(acceptTapped)
        )

        let disagree = NSLocalizedString("disagree_and_quit", comment: "")
        let declineButton = createButton(
            title: disagree, // 替换为实际文本
            backgroundColor: UIColor(hex: 0xFAFAFA),
            textColor: UIColor(hex: 0x323232),
            action: #selector(declineTapped)
        )
        declineButton.layer.borderWidth = 0.5
        declineButton.layer.borderColor = UIColor.gray.cgColor
    

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
            make.width.equalTo((screenWidth - 50 - 30 - 30) / 2)
            make.height.equalTo(40)
        }

        declineButton.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-16)
            make.leading.equalTo(view).offset(16)
            make.width.height.equalTo(acceptButton)
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
    
    // 通用按钮创建方法
    func createButton(title: String, backgroundColor: UIColor, textColor: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 2.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
