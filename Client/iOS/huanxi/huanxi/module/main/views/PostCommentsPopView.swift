//
//  PostCommentsPopView.swift
//  huanxi
//
//  Created by rslz on 2024/11/11.
//

import Foundation
import UIKit
import Kingfisher

class PostCommentsPopView:UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, CommentTextViewDelegate,DrawerViewDelegate {
    
    let topLine = UIView()
    let titlelabel = UILabel()
    var awemeId:String?
    var visitor:VisitorModel = VisitorModel.read()
    
    var pageIndex:Int = 0
    var pageSize:Int = 20
    let container = UIView.init()
    var tableView = UITableView.init()
    var data = [CommentModel]()
    let textView = CommentTextView()
    var loadMore:LoadMoreControl?
    let drawerView = DrawerView()

    init(awemeId:String) {
        super.init(frame: UIScreen.main.bounds)
        self.awemeId = awemeId
        initSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    
    
    func initSubView() {
        
        drawerView.accessibilityIdentifier = "drawer"
        drawerView.backgroundColor = UIColor.postBgColor
        drawerView.snapPositions = [.closed, .partiallyOpen, .open]
        drawerView.position = .partiallyOpen
        drawerView.partiallyOpenHeight = screenHeight * 3 / 5
        drawerView.delegate = self
        
        container.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight * 3 / 5)
        drawerView.addSubview(container)
        let rounded = UIBezierPath.init(roundedRect: CGRect.init(origin: .zero, size: CGSize.init(width: screenWidth, height: screenHeight * 3 / 4)), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 10.0, height: 10.0))
        let shape = CAShapeLayer.init()
        shape.path = rounded.cgPath
        container.layer.mask = shape
        
        topLine.backgroundColor = UIColor.lightGray
        topLine.translatesAutoresizingMaskIntoConstraints = false
        topLine.layer.cornerRadius = 2
        topLine.clipsToBounds = true
        container.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(40)
        }
        

        titlelabel.frame = CGRect.init(origin: .zero, size: CGSize.init(width: screenWidth, height: 35))
        titlelabel.textAlignment = .center
        titlelabel.text = "评论"
        titlelabel.textColor = .white
        titlelabel.font = UIFont.boldSystemFont(ofSize: 15)
        container.addSubview(titlelabel)
        titlelabel.snp.makeConstraints { make in
            make.top.equalTo(topLine.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
        }
        

        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 35, width: screenWidth, height: screenHeight*3/4 - 35 - 50 - CGFloat.bottomSafeAreaHeight), style: .grouped)
        tableView.backgroundColor = .clear
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: self.tableView.bounds.width, height: 0.01)))
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(CommentsListCell.classForCoder(), forCellReuseIdentifier: CommentsListCell.identifier)
        container.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titlelabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(CGFloat.bottomSafeAreaHeight)
        }
        
        loadMore = LoadMoreControl.init(frame: CGRect.init(x: 0, y: 100, width: screenWidth, height: 50), surplusCount: 10)
        loadMore?.startLoading()
        loadMore?.onLoad = {[weak self] in
            self?.loadData(page: self?.pageIndex ?? 0)
        }
        tableView.addSubview(loadMore!)
        

        textView.delegate = self
        
        loadData(page: pageIndex)
    }
    
    func drawerDidMove(_ drawerView: DrawerView, drawerOffset: CGFloat) {
        self.textView.dismiss()
    }

    
    func onSendText(text: String) {
        var comment = CommentModel()
        comment.text = text
        let currentTimestampInMilliseconds = Date().timeIntervalSince1970
        comment.create_time = Int(currentTimestampInMilliseconds)
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.data.insert(comment, at: 0)
        var indexPaths = [IndexPath]()
        indexPaths.append(IndexPath.init(row: 0, section: 0))
        self.tableView.insertRows(at: indexPaths, with: .none)
        self.tableView.endUpdates()
        self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
        UIView.setAnimationsEnabled(true)
    }
    
    func deleteComment(comment:CommentModel){
        if let index = self.data.firstIndex(where: { $0.taskId == comment.taskId }) {
            self.tableView.beginUpdates()
            self.data.remove(at: index)
            var indexPaths = [IndexPath]()
            indexPaths.append(IndexPath.init(row: index, section: 0))
            self.tableView.deleteRows(at: indexPaths, with: .right)
            self.tableView.endUpdates()
            HUDHelper.showToast("评论删除成功")
        } else {
            HUDHelper.showToast("评论删除失败")
        }
    }
    
    func loadData(page:Int, _ size:Int = 20) {
        // 模拟 2 秒的延迟
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            // 模拟请求结果
            let array: [CommentModel] = []
        
            // 返回主线程更新 UI 或处理结果
            DispatchQueue.main.async {
                self.pageIndex += 1
                UIView.setAnimationsEnabled(false)
                self.tableView.beginUpdates()
                self.data += array
                var indexPaths = [IndexPath]()
                for row in (self.data.count - array.count)..<self.data.count {
                    let indexPath = IndexPath.init(row: row, section: 0)
                    indexPaths.append(indexPath)
                }
                self.tableView.insertRows(at: indexPaths, with: .none)
                self.tableView.endUpdates()
                UIView.setAnimationsEnabled(true)
                
                self.loadMore?.endLoading()
//                if response.has_more == 0 {
                    self.loadMore?.loadingAll()
//                }
            }
        }
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommentsListCell.cellHeight(comment: data[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentsListCell.identifier) as! CommentsListCell
        cell.initData(comment: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let comment = data[indexPath.row]
//        if !comment.isTemp && comment.user_type == "visitor" && MD5_UDID == comment.visitor?.udid {
//            let menu = MenuPopView.init(titles: ["删除"])
//            menu.onAction = {[weak self] index in
//                self?.deleteComment(comment: comment)
//            }
//            menu.show()
//        }
    }


    
    func show(view: UIView) {
        if let window = getKeyWindow() {
            drawerView.attachTo(view: window)
            DispatchQueue.global().asyncAfter(deadline: .now() + .microseconds(500)) {
                DispatchQueue.main.async {
                    self.textView.show()
                }
            }
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol CommentTextViewDelegate:NSObjectProtocol {
    func onSendText(text:String)
}

class CommentTextView:UIView, UITextViewDelegate {
    
    var leftInset:CGFloat = 15
    var rightInset:CGFloat = 60
    var topBottomInset:CGFloat = 15
    
    var container = UIView.init()
    var textView = UITextView.init()
    var delegate:CommentTextViewDelegate?
    
    var textHeight:CGFloat = 0
    var keyboardHeight:CGFloat = 0
    var placeHolderLabel = UILabel.init()
    var atImageView = UIImageView.init(image: UIImage.init(named: "post_comment_mark"))
    var visualEffectView = UIVisualEffectView.init()
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        initSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    
    
    func initSubView() {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = .clear
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGuestrue(sender:))))
        
        self.addSubview(container)
        container.backgroundColor = UIColor.black_40
        
        keyboardHeight = CGFloat.bottomSafeAreaHeight
        
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
        
        placeHolderLabel.frame = CGRect.init(x:15, y:0, width:screenWidth - 15 - 85, height:50)
        placeHolderLabel.text = "有爱评论，说点儿好听的~"
        placeHolderLabel.textColor = .gray
        placeHolderLabel.font = UIFont.systemFont(ofSize: 16.0)
        textView.addSubview(placeHolderLabel)
        //        textView.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        
        atImageView.contentMode = .center
        textView.addSubview(atImageView)
        
        textView.delegate = self
        container.addSubview(textView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        atImageView.frame = CGRect.init(x: screenWidth - 50, y: 0, width: 50, height: 50)
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
            delegate?.onSendText(text: textView.text)
            textView.text = ""
            textHeight = textView.font?.lineHeight ?? 0
            textView.resignFirstResponder()
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
    
    func show() {
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
