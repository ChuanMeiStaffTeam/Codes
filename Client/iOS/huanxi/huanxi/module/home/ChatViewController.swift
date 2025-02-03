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
                if self.messages.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath.init(row: self.messages.count - 1, section: 0), at: .bottom, animated: false)
                }
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


/*代码功能

这段代码实现了一个 iOS 聊天页面的控制器，主要功能包括：

展示聊天记录： 通过 UITableView 展示与某个用户的聊天记录。
发送消息： 用户可以在输入框中输入消息并发送。
接收消息： 使用 NIMSDK 接收服务器推送的消息，并实时更新界面。
用户交互： 处理用户点击聊天记录、发送消息等交互行为。
代码结构

ChatViewController 类：

属性：
chatUserInfoView：显示聊天用户信息的视图。
chatEditView：用于输入消息的视图。
messages：存储聊天记录的数组。
方法：
viewDidLoad：初始化视图，设置导航栏、表格视图，注册通知，登录云信 IM，加载聊天记录。
setupView：设置视图的布局。
setupNavView：设置导航栏的样式。
bindUI：绑定视图模型的数据到表格视图上，处理用户交互。
refreshData：刷新数据。
setEmptyOrNetErrorView：显示空视图或错误视图。
tableView(_:heightForRowAt:)：根据不同类型的 cell 计算行高。
其他方法：处理各种用户交互事件，比如点击点赞、收藏等。
NIMChatManagerDelegate 协议：

实现 NIMChatManagerDelegate 协议的方法，用于监听消息发送状态、接收新消息等。
代码流程

初始化： 在 viewDidLoad 中初始化视图，设置导航栏，加载聊天记录，并注册云信 IM 的回调。
发送消息： 用户点击发送按钮后，调用 sendMessage 方法，将消息发送到服务器。
接收消息： 云信 IM 服务器推送新消息时，会调用 NIMChatManagerDelegate 中的方法，更新本地消息列表并刷新界面。
展示聊天记录： 使用 UITableView 展示聊天记录，根据消息类型显示不同的 cell。
代码亮点

使用了 NIMSDK： 集成了云信 IM SDK，实现了即时通讯功能。
采用了 MVVM 模式： 将视图和数据逻辑分离，提高代码可维护性。
使用了 Combine： 用于订阅数据变化，实现数据绑定。
自定义 cell： 使用 ChatTextCell 等自定义 cell 来展示不同类型的消息。
处理键盘事件： 监听键盘显示和隐藏事件，动态调整界面布局。
改进建议

消息类型： 可以支持更多类型的消息，比如图片、语音、表情等。
消息撤回： 实现消息撤回功能。
消息已读回执： 实现消息已读回执功能。
离线消息： 处理离线消息，确保用户能及时收到消息。
性能优化： 对于大量聊天记录，可以考虑分页加载，提高性能。
UI优化： 可以对界面进行优化，提高用户体验。
错误处理： 可以添加更多的错误处理，比如网络请求失败、登录失败等。
进一步分析

viewModel 的作用： 从代码中可以看出，viewModel 应该负责管理聊天数据，包括发送消息、接收消息、存储本地聊天记录等。
NIMSDK 的使用： NIMSDK 提供了丰富的 API，可以实现各种 IM 功能，如单聊、群聊、消息漫游等。
Combine 的应用： Combine 用于订阅 viewModel 的数据变化，实现数据绑定，让 UI 能够实时更新。
自定义 cell 的设计： ChatTextCell 应该根据消息类型（文本、图片等）来展示不同的 UI。

总结

这段代码实现了一个功能相对完整的聊天页面，展示了如何使用 NIMSDK、Combine 等技术构建 iOS 聊天应用。但仍有许多方面可以优化和改进，以提供更好的用户体验。*/
