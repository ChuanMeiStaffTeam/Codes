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
        if let urlStr = self.user.profilePictureUrl {
            avatar.image = UIImage.init(named: urlStr)
        }
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
