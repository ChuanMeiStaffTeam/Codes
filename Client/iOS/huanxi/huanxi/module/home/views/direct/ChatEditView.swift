//
//  ChatEditView.swift
//  huanxi
//
//  Created by Jack on 2024/6/13.
//

import UIKit

protocol ChatEditDelegate: AnyObject {
    func sendText(_ text: String?)
}

class ChatEditView: UIView {
    
    weak var delegate: ChatEditDelegate?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        
        backgroundColor = .black
        
        let line = UIView.init(frame: CGRect.zero)
        line.backgroundColor = .init(hex: 0x333333)
        addSubview(line)
        line.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().offset(0)
            make.height.equalTo(0.75)
        }
        
        addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(11)
            make.height.equalTo(40)
        }
    }
    
    lazy var textView: UITextView = {
        let view = UITextView.init(frame: CGRect.zero)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = .init(hex: 0x171717)
        view.delegate = self
        view.returnKeyType = .send
        view.textColor = .white
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.textContainerInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        return view
    }()
}


extension ChatEditView: UITextViewDelegate {
    // UITextView 处理“发送”按钮点击事件
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 检查按下的键是否为“发送”键
        if text == "\n" {
            // 调用发送方法
            sendText(textView.text)
            return false // 防止换行
        }
        return true
    }

    // 发送文本的函数
    func sendText(_ text: String?) {
        // 处理发送逻辑
        if let text = text {//, !text.isEmpty
            print("发送文本: \(text)")
            delegate?.sendText(text)
        }
    }
}
