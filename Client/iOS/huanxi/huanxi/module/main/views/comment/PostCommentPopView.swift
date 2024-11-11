//
//  PostCommentsPopView.swift
//  huanxi
//
//  Created by rslz on 2024/11/11.
//

import Foundation
import UIKit
import Kingfisher

class PostCommentPopView: UIView {
    
    var pageIndex:Int = 0
    var pageSize:Int = 20
    var awemeId:String?
    var visitor:VisitorModel = VisitorModel.read()
    var data = [CommentModel]()
    var postModel: PostModel = PostModel(liked: false, collected: false)

    let topLine = UIView()
    let titlelabel = UILabel()
    let container = UIView.init()
    var tableView = UITableView.init()
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
        tableView.register(CommentListCell.classForCoder(), forCellReuseIdentifier: CommentListCell.identifier)
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

    

    func show(_ postModel: PostModel) {
        self.postModel = postModel
        if let window = getKeyWindow() {
            drawerView.attachTo(view: window)
            DispatchQueue.global().asyncAfter(deadline: .now() + .microseconds(500)) {
                DispatchQueue.main.async {
                    self.textView.show(self.postModel.user ?? UserInfoModel())
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


extension PostCommentPopView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommentListCell.cellHeight(comment: data[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentListCell.identifier) as! CommentListCell
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
}

extension PostCommentPopView: CommentTextViewDelegate {
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
}

extension PostCommentPopView: DrawerViewDelegate {
    
    func drawerDidMove(_ drawerView: DrawerView, drawerOffset: CGFloat) {
    }
    
    func drawer(_ drawerView: DrawerView, didTransitionTo position: DrawerPosition) {
    }
    
    func drawer(_ drawerView: DrawerView, willTransitionFrom startPosition: DrawerPosition, to targetPosition: DrawerPosition) {
        if targetPosition == .closed {
            self.textView.dismiss()
        }
    }
}
