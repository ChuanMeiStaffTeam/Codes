//
//  ChatViewController.swift
//  huanxi
//
//  Created by Jack on 2024/6/4.
//

import UIKit
import NIMSDK
//import IQKeyboardManagerSwift

class ChatViewController: BaseViewController {
    
    let chatUserInfoView = ChatUserInfoView()
    let chatEditView = ChatEditView()
    
    var messages: [NIMMessage] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserver()

        setupView()
        
        NIMSDK.shared().chatManager.add(self)
        
        resetMessages()
        
//        IQKeyboardManager.shared.enableAutoToolbar = false // 默认是 true
//        IQKeyboardManager.shared.resignOnTouchOutside = true // 当点击键盘外部时，键盘是否应该关闭
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // 键盘将显示时的处理
        chatEditView.snp.updateConstraints { make in
            make.height.equalTo(62)
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        // 键盘将隐藏时的处理
        chatEditView.snp.updateConstraints { make in
            make.height.equalTo(CGFloat.bottomSafeAreaHeight + 62)
        }
    }
    
    func setupView() {
        self.title = "yao.D.C"

        chatUserInfoView.isHidden = false
        view.addSubview(chatUserInfoView)
        chatUserInfoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(CGFloat.topBarHeight)
        }
        
        chatEditView.delegate = self
        view.addSubview(chatEditView)
        chatEditView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().offset(0)
            make.height.equalTo(CGFloat.bottomSafeAreaHeight + 62)
        }
        
        view.addSubview(tableView)
        
        
    }
    
    func showUserInfo(_ hidden: Bool) {
        chatUserInfoView.isHidden = hidden
        if hidden {
            tableView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview().offset(0)
                make.top.equalTo(chatUserInfoView.snp.top).offset(0)
                make.bottom.equalTo(chatEditView.snp.top).offset(0)
            }
        } else {
            tableView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview().offset(0)
                make.top.equalTo(chatUserInfoView.snp.bottom).offset(0)
                make.bottom.equalTo(chatEditView.snp.top).offset(0)
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(ChatTextCell.self, forCellReuseIdentifier: "ChatTextCell")
        return view
    }()

}


extension ChatViewController: ChatEditDelegate {
    func sendText(_ text: String?) {
        sendMessage()
    }
}


extension ChatViewController: NIMChatManagerDelegate {
    
    func sendMessage() {

        guard !chatEditView.textView.text.isEmpty else {
            HUDHelper.showToast("请输入消息内容")
            return
        }
        
        let session = NIMSession.init("test01", type: .P2P)
        let message = NIMMessage()
        message.text = chatEditView.textView.text
        NIMSDK.shared().chatManager.send(message,
                                         to: session) { error in
            if let error = error {
                HUDHelper.showToast("消息发送失败")
                print(error)
            } else {
                self.chatEditView.textView.text = ""
                self.resetMessages()
            }
        }
    }
    
    //回调方法监听，此处为消息即将发送事件
    func willSend(_ message: NIMMessage) {
        print("will send message")
    }

    //发送进度回调
    func send(_ message: NIMMessage, progress: Float) {
        print("send message progress \(progress)")
    }

    //消息发送完成回调
    //发送结果
    func send(_ message: NIMMessage, didCompleteWithError error: (any Error)?) {
        print("send message complete")
    }
    
    
    
    func resetMessages() {
        let session = NIMSession.init("test01", type: .P2P)
        NIMSDK.shared().conversationManager.messages(in: session, message: nil, limit: 100) { error, messages in
            if let error = error {
                print(error)
            } else {
                self.messages = messages ?? []
                self.showUserInfo(!self.messages.isEmpty)
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath.init(row: self.messages.count - 1, section: 0), at: .bottom, animated: false)
            }
        }
    }

}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ChatTextCell.init(style: .default, reuseIdentifier: "ChatTextCell")
        let message = messages[indexPath.row]
        cell.labelWidth = ChatMessageManager.calculatTextWidth(message: message)
        cell.message = message
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messages[indexPath.row]
        return ChatMessageManager.calculatCellHeight(message: message)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatUserHomeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
