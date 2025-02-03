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

/*代码功能

这段代码定义了一个名为 ChatEditView 的自定义视图，主要用于在聊天应用中提供一个输入框，让用户输入聊天内容。它可以看作是一个聊天输入框组件。

代码结构

类定义: ChatEditView 继承自 UIView，是一个自定义的视图类。
属性:
delegate: 一个弱引用，指向实现了 ChatEditDelegate 协议的对象。这个代理对象负责处理发送消息的逻辑。
textView: 一个 UITextView 实例，用于输入聊天内容。
方法:
init(coder:): 这个初始化方法通常用于从 Interface Builder 中加载视图，这里标记为未实现。
init(frame:): 这个初始化方法用于在代码中创建视图实例，设置视图的初始大小和位置，并调用 setupView 方法进行布局。
setupView(): 这个方法用于设置视图的布局，使用 SnapKit 这个第三方库来定义各个子视图的约束，从而实现自适应布局。
textView(_:shouldChangeTextIn:replacementText:): 这个方法是 UITextViewDelegate 协议中的一个方法，用于监听文本视图中的文本变化。当用户按下回车键（即“发送”按钮）时，会调用这个方法，然后触发发送消息的逻辑。
sendText(_:): 这个方法用于发送消息，它会将输入的文本内容通过代理传递给外部对象进行处理。
代码逻辑

创建视图: 当创建 ChatEditView 实例时，会调用 init(frame:) 方法，进而调用 setupView 方法。
设置布局: setupView 方法使用 SnapKit 定义 textView 的约束，使其占据视图的大部分区域。
发送消息: 当用户在 textView 中输入完消息并按下回车键时，会触发 textView(_:shouldChangeTextIn:replacementText:) 方法。在这个方法中，会调用 sendText(_:) 方法，将输入的文本内容通过代理传递出去。
代码亮点

使用 SnapKit: 使用 SnapKit 来定义约束，使得布局更加灵活和可维护。
代理模式: 通过 ChatEditDelegate 协议，将发送消息的逻辑从视图中分离出来，提高了代码的可扩展性。
自定义外观: 可以通过修改 textView 的样式来定制输入框的外观。
代码改进建议

处理空文本: 可以添加判断，防止发送空文本。
添加表情输入: 可以集成表情输入功能。
支持语音输入: 可以添加语音输入功能。
优化键盘弹出与收起: 可以优化键盘弹出和收起时的动画效果。
总结

 这段代码实现了一个简单的聊天输入框组件，可以作为聊天应用的基础组件。通过自定义和扩展，可以实现更加丰富和灵活的聊天功能。*/
