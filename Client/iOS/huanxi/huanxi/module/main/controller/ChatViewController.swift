//
//  ChatViewController.swift
//  huanxi
//
//  Created by Jack on 2024/6/4.
//

import UIKit
import NIMSDK

class ChatViewController: BaseViewController {
    
    let chatUserInfoView = ChatUserInfoView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        NIMSDK.shared().chatManager.add(self)
        
        resetMessages()
    }
    
    func setupView() {
        self.title = "yao.D.C"

        view.addSubview(chatUserInfoView)
        chatUserInfoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(CGFloat.topBarHeight)
        }
        
    }
    
//    lazy var tableView: UITableView = {
//        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
//        view.backgroundColor = .clear
//        view.delegate = self
//        view.dataSource = self
//        view.register(DirectChatCell.self, forCellReuseIdentifier: "DirectChatCell")
//        return view
//    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendMessage()
    }
}


extension ChatViewController: NIMChatManagerDelegate {
    
    func sendMessage() {
        
        do {
            let session = NIMSession.init("test02", type: .P2P)
            let message = NIMMessage()
            message.text = "hello"
            try NIMSDK.shared().chatManager.sendForwardMessage(message, to: session)
        } catch {
            print(error)
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
        let session = NIMSession.init("test02", type: .P2P)
        NIMSDK.shared().conversationManager.messages(in: session, message: nil, limit: 100) { error, messages in
            if let error = error {
                print(error)
            }
        }
        
    }

}

//extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return chatList.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = DirectChatCell.init(style: .default, reuseIdentifier: "DirectChatCell")
//        let model = chatList[indexPath.row]
//        cell.reloadData(model)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 72
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = ChatViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//}
