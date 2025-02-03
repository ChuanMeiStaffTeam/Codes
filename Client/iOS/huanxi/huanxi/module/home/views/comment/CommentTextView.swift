//
//  CommentTextView.swift
//  huanxi
//
//  Created by rslz on 2024/11/11.
//

import Foundation
import UIKit

protocol CommentTextViewDelegate:NSObjectProtocol {
    func onSendText(text:String)
}

class CommentTextView:UIView, UITextViewDelegate {
    
    var leftInset:CGFloat = 15 + 35
    var rightInset:CGFloat = 60
    var topBottomInset:CGFloat = 15
    var textHeight:CGFloat = 0
    var keyboardHeight:CGFloat = CGFloat.bottomSafeAreaHeight
    
    var delegate:CommentTextViewDelegate?
    var user = UserInfoModel()

    var container = UIView.init()
    var textView = UITextView.init()
    var placeHolderLabel = UILabel.init()
    let avatar = UIImageView()
    var atImageView = UIImageView.init(image: UIImage.init(named: "post_comment_mark"))
    var visualEffectView = UIVisualEffectView.init()
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        initSubView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func initSubView() {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = .clear
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGuestrue(sender:))))
        
        self.addSubview(container)
        container.backgroundColor = UIColor.black_40
                
        textView = UITextView.init()
        textView.backgroundColor = .clear
        textView.clipsToBounds = false
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 16.0)
        textView.returnKeyType = .send
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets(top: topBottomInset, left: leftInset, bottom: topBottomInset, right: rightInset)
        textHeight = textView.font?.lineHeight ?? 0
        textView.delegate = self
        container.addSubview(textView)
        
        
        let user = LoginManager.shared.getUserInfo()
        let defaultAvatar = UIImage(resource: .imgFindDefault)
        avatar.kf.setImage(with: URL(string: user?.profilePictureUrl ?? ""), placeholder: defaultAvatar)
        avatar.layer.cornerRadius = 16
        avatar.layer.masksToBounds = true
        textView.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.centerY.equalTo(textView.snp.centerY)
            make.left.equalTo(10)
        }
        
        placeHolderLabel.textColor = .gray
        placeHolderLabel.font = UIFont.systemFont(ofSize: 14.0)
        textView.addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { make in
            make.width.equalTo(screenWidth - 15 - 85)
            make.height.equalTo(50)
            make.left.equalTo(avatar.snp.right).offset(15)
            make.centerY.equalTo(textView.snp.centerY)
        }
        
        atImageView.contentMode = .center
        textView.addSubview(atImageView)
        atImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.right.equalTo(screenWidth)
            make.centerY.equalTo(textView.snp.centerY)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let rounded = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 10.0, height: 10.0))
        let shape = CAShapeLayer.init()
        shape.path = rounded.cgPath
        container.layer.mask = shape
        
        updateTextViewFrame()
    }
    
    func updateTextViewFrame() {
        let textViewHeight = keyboardHeight > CGFloat.bottomSafeAreaHeight ? textHeight + 2 * topBottomInset : (textView.font?.lineHeight ?? 0) + 2*topBottomInset
        textView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: textViewHeight)
        container.frame = CGRect.init(x: 0, y: screenHeight - keyboardHeight - textViewHeight, width: screenWidth, height: textViewHeight + keyboardHeight)
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        keyboardHeight = notification.keyBoardHeight()
        updateTextViewFrame()
        atImageView.image = UIImage.init(named: "post_comment_mark_b")
        container.backgroundColor = .white
        textView.textColor = .black
        self.backgroundColor = UIColor.black_60
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        keyboardHeight = CGFloat.bottomSafeAreaHeight
        updateTextViewFrame()
        atImageView.image = UIImage.init(named: "post_comment_mark")
        container.backgroundColor = UIColor.black_40
        textView.textColor = .white
        self.backgroundColor = .clear
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let attributeText = NSMutableAttributedString.init(attributedString: textView.attributedText)
        if !textView.hasText {
            placeHolderLabel.isHidden = false
            textHeight = textView.font?.lineHeight ?? 0
        } else {
            placeHolderLabel.isHidden = true
            textHeight = attributeText.multiLineSize(width: screenWidth - leftInset - rightInset).height
        }
        updateTextViewFrame()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if !textView.text.isEmpty {
                delegate?.onSendText(text: textView.text)
                textView.text = ""
                textHeight = textView.font?.lineHeight ?? 0
                placeHolderLabel.isHidden = false
                textView.resignFirstResponder()
            } else {
                HUDHelper.showToast("请输入内容")
            }
        }
        return true
    }
    
    @objc func handleGuestrue(sender:UITapGestureRecognizer) {
        let point = sender.location(in: textView)
        if !(textView.layer.contains(point)) {
            textView.resignFirstResponder()
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            if hitView?.backgroundColor == .clear {
                return nil
            }
        }
        return hitView
    }
    
    func show(_ user: UserInfoModel) {
        self.user = user
        placeHolderLabel.text = "为\(user.fullName ?? "")添加评论..."
        if let window = getKeyWindow() {
            window.addSubview(self)
        }
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


/*代码功能:

这段代码定义了一个名为 CommentTextView 的自定义视图，用于在应用程序中创建评论输入框。

主要特点:

外观:

包含一个可编辑的文本视图 (textView)，用于输入评论内容。
显示用户的头像 (avatar)。
显示占位符文本 (placeHolderLabel)，提示用户输入评论。
显示一个 "@" 符号的图像 (atImageView)，表示这是一个评论输入框。
支持动态调整高度，以适应不同长度的评论文本。
具有圆角边框。
交互:

用户可以在文本视图中输入评论内容。
当用户按下回车键时，会触发发送评论的事件，并将输入的文本传递给 delegate。
点击屏幕其他区域会隐藏键盘。
键盘处理:

监听键盘的显示和隐藏事件，动态调整视图的位置和大小。
自定义:

可以通过 show(_:) 方法传入用户信息，设置占位符文本。
可以通过 dismiss() 方法将评论输入框从屏幕上移除。
代码实现细节:

使用 UITextView 作为主要输入控件。
使用 NSNotificationCenter 监听键盘事件。
使用 snp.makeConstraints 进行自动布局。
使用 UIBezierPath 和 CAShapeLayer 创建圆角边框。
使用 delegate 模式将评论发送事件通知给其他对象。
代码中的关键类和方法:

CommentTextView: 自定义视图类。
CommentTextViewDelegate: 协议，定义了 onSendText(text:String) 方法，用于接收发送的评论文本。
initSubView(): 初始化子视图的方法。
updateTextViewFrame(): 更新文本视图和容器视图的帧的方法。
keyboardWillShow(notification:): 键盘显示事件的处理方法。
keyboardWillHide(notification:): 键盘隐藏事件的处理方法。
textViewDidChange(_:): 文本视图内容发生变化时的处理方法。
textView(_:shouldChangeTextIn:replacementText:): 处理用户输入的方法。
handleGuestrue(sender:): 处理点击事件的方法。
show(_:): 显示评论输入框的方法。
dismiss(): 隐藏评论输入框的方法。
总结:

 这段代码实现了一个功能完善、易于使用的评论输入框组件，可以方便地集成到其他应用程序中。它具有良好的交互性、可扩展性和可维护性。*/
