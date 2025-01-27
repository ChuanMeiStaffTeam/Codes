//
//  PrivacyviewController.swift
//  huanxi
//
//  Created by rslz on 2024/11/17.
//

import UIKit
import SnapKit
import QuickLook

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
        messageLabel.onTextTapped = { [weak self] string, range, index in
            guard let `self` = self else { return }
            print("点击了: \(string), 范围: \(range), 索引: \(index)")
            let docxName = string.contains("用户协议") ? "欢喜用户协议" : "欢喜隐私协议"
            let filePath = Bundle.main.path(forResource: docxName, ofType: "docx") ?? ""
            DocumentPreviewer.shared.show(from: self, filePaths: [filePath]) {
                print("文件预览完成")
            }
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

/*代码功能:
 
 显示一个包含标题、消息（包括可点击链接的富文本）、同意和不同意按钮的弹出窗口。
 点击同意按钮会关闭弹出窗口，并可选择在稍后调用提供的回调函数。
 点击不同意按钮会退出应用程序。
 处理消息中的链接点击，允许用户预览链接的文档（可能是隐私政策和用户协议）。
 改进建议:

 错误处理: 考虑添加错误处理，以防找不到链接的文档。
 可访问性: 确保弹出窗口对残障人士友好（例如，适当的色彩对比度、屏幕阅读器兼容性）。
 可定制性: 通过属性或函数允许更多地定制弹出窗口的外观（例如，字体大小、颜色、按钮样式）。
 关闭按钮: 可以添加一个可选的关闭按钮，为用户提供一种无需同意或不同意即可关闭弹出窗口的方式。
 拒绝按钮逻辑: 拒绝按钮可以不退出整个应用程序，而是将用户导航到另一个屏幕，解释不同意的后果或提供其他选项。
 其他注意事项:

 createButton 函数是一种可重用的方式来创建具有特定样式的按钮。
 QuickLook 框架用于显示链接文档的预览。
 总体而言，该代码有效地实现了具有核心功能的隐私政策弹出窗口。建议的改进可以进一步增强用户体验并提供更大的灵活性。*/
