//
//  PostCommentsPopView.swift
//  huanxi
//
//  Created by rslz on 2024/11/11.
//

import Foundation
import UIKit
import Kingfisher

class PostCommentPopView: BaseView {
    
    private let viewModel = CommentViewModel()

    var postId: Int = 0
    var visitor:VisitorModel = VisitorModel.read()
    var data = [CommentModel]()
    var postModel: PostModel = PostModel(liked: false)


    let textView = CommentTextView()
    
    lazy var drawerView: DrawerView = {
        let drawerView = DrawerView()
        drawerView.accessibilityIdentifier = "drawer"
        drawerView.backgroundColor = UIColor.black
//        drawerView.snapPositions = [.closed, .partiallyOpen, .open]
//        drawerView.position = .partiallyOpen
//        drawerView.partiallyOpenHeight = screenHeight * 3 / 5
        
        drawerView.snapPositions = [.closed, .open]
        drawerView.position = .open
        drawerView.openHeightBehavior = .fixed(height: screenHeight * 3 / 5)
        drawerView.insetAdjustmentBehavior = .fixed(70)
        drawerView.delegate = self
        return drawerView
    }()
    
    let container: UIView = UIView().then({view in
        view.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight * 3 / 5)
    })
    
    private let topLine: UIView = UIView().then({view in
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
    })
    
    private let titlelabel: UILabel = UILabel().then({view in
        view.textAlignment = .center
        view.text = "评论"
        view.textColor = .white
        view.font = UIFont.boldSystemFont(ofSize: 15)
    })
   

    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .plain)
        tableView.backgroundColor = .clear
//        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0)
        tableView.separatorStyle = .none
        tableView.register(CommentListCell.self)
        return tableView
    }()
    
    
    private let emptyView = UILabel().then({ view in
        view.text = "暂无评论"
        view.textColor = UIColor.white_60
        view.font = UIFont.systemFont(ofSize: 14)
        view.textAlignment = .center
    })
    
    init(postId: Int) {
        super.init(frame: UIScreen.main.bounds)
        self.postId = postId
        setupUI()
        bindUI()
        Task {
            await self.viewModel.fetchComments(postId)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        
        drawerView.addSubview(container)
        let rounded = UIBezierPath.init(roundedRect: CGRect.init(origin: .zero, size: CGSize.init(width: screenWidth, height: screenHeight * 3 / 4)), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 10.0, height: 10.0))
        let shape = CAShapeLayer.init()
        shape.path = rounded.cgPath
        container.layer.mask = shape
        

        container.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(40)
        }
        

        container.addSubview(titlelabel)
        titlelabel.snp.makeConstraints { make in
            make.top.equalTo(topLine.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
        }
        

        container.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titlelabel.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
            make.bottom.equalTo(0)
        }
        
        textView.delegate = self
        
    }
    
    func bindUI(){
        
        tableView.rx.setDelegate(self)
                    .disposed(by: disposeBag)
        
        viewModel.commentList
            .bind(to: tableView.rx.items) { tableView, index, item in
                switch item {
                case .skeleton:
                    let cell: CommentListCell = tableView.dequeueReusableCell(forIndexPath: IndexPath(row: index, section: 0))
                    cell.isSkeletonVisible = true
                    return cell
                case .commentItem(let model):
                    let cell: CommentListCell = tableView.dequeueReusableCell(forIndexPath: IndexPath(row: index, section: 0))
                    cell.model = model
                    cell.isSkeletonVisible = false
                    return cell
                default:
                    let cell: UITableViewCell = UITableViewCell().then({ view in
                        view.backgroundColor = .clear
                    })
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.commentList
            .subscribe(onNext: { [weak self] cellTypes in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    if cellTypes.isEmpty {
                        self.emptyView.removeFromSuperview()
                        self.container.addSubview(self.emptyView)
                        self.emptyView.snp.makeConstraints { make in
                            make.centerY.equalToSuperview().offset(-50)
                            make.centerX.equalToSuperview()
                            make.size.equalTo(CGSize(width: UIDevice.screenWidth, height: 300))
                        }
                    } else {
                        self.emptyView.removeFromSuperview()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        // Usage example
        tableView.rx.itemLongPressed
            .subscribe(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                
                guard let item = self.viewModel.commentList.value.ck_objIndex(indexPath.item) else {
                    return
                }
                switch item {
                case .commentItem(let item):
                    let userInfo = LoginManager.shared.getUserInfo()
                    if item.sysComment?.userId != userInfo?.userId {
                        return
                    }
                    let postMorePopView = PostMorePopView()
                    var model = PostModel(liked: false)
                    model.userId = userInfo?.userId
                    postMorePopView.show(model, type: .delete)
                    postMorePopView.trashButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        postMorePopView.close()
                        Task {
                            await self.viewModel.fetcDeleteComment(self.postId, parentCommentId: item.sysComment?.parentCommentId, commentId: item.sysComment?.commentId ?? 0, indexPath: indexPath)
                        }
                       
                    }).disposed(by: disposeBag)
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
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

}


extension PostCommentPopView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = self.viewModel.commentList.value.ck_objIndex(indexPath.item) else {
            return 0
        }
        switch item {
        case .skeleton:
            return 60
        case .commentItem(let item):
            return CommentListCell.cellHeight(comment: item)
        default:
            return 0
        }
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
//        var comment = CommentModel()
//        comment.text = text
//        let currentTimestampInMilliseconds = Date().timeIntervalSince1970
//        comment.create_time = Int(currentTimestampInMilliseconds)
//        UIView.setAnimationsEnabled(false)
//        self.tableView.beginUpdates()
//        self.data.insert(comment, at: 0)
//        var indexPaths = [IndexPath]()
//        indexPaths.append(IndexPath.init(row: 0, section: 0))
//        self.tableView.insertRows(at: indexPaths, with: .none)
//        self.tableView.endUpdates()
//        self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
//        UIView.setAnimationsEnabled(true)
    
        Task {
            await self.viewModel.fetcAddComment(self.postId, parentCommentId: 0, content: text)
        }
    }
}

extension PostCommentPopView: DrawerViewDelegate {
    
    func drawerDidMove(_ drawerView: DrawerView, drawerOffset: CGFloat) {
    }
    
    func drawer(_ drawerView: DrawerView, didTransitionTo position: DrawerPosition) {
    }
    
    func drawer(_ drawerView: DrawerView, willTransitionFrom startPosition: DrawerPosition, to targetPosition: DrawerPosition) {
        if targetPosition == .closed {
            self.removeFromSuperview()
            self.textView.dismiss()
        }
    }
}


/*代码功能

这段代码定义了一个名为 PostCommentPopView 的类，用于创建一个显示帖子评论的弹出视图。这个视图主要用于展示一个帖子的评论列表，并允许用户添加新的评论。

主要功能：

展示评论列表: 通过 tableView 显示评论列表，支持骨架屏、评论单元格、空状态和错误状态等不同的单元格类型。
添加评论: 用户可以在 textView 中输入评论内容，点击发送按钮后，会将评论提交到服务器，并更新列表。
删除评论: 用户长按评论单元格，可以弹出菜单，选择删除评论，并发送删除请求到服务器。
与 CommentViewModel 交互: 通过 viewModel 对象与后台数据进行交互，获取评论列表、添加评论和删除评论。
代码结构

CellType 枚举: 定义了列表中可能出现的单元格类型。
HomeViewModel 类:
dataList: 用 BehaviorRelay 存储评论数据，实时更新 UI。
fetchComments, fetcAddComment, fetcDeleteComment: 分别用于获取评论列表、添加评论和删除评论。
PostCommentPopView 类:
drawerView: 一个可滑动的抽屉视图，用于展示评论列表。
tableView: 显示评论列表的 UITableView。
textView: 用于输入评论的文本框。
viewModel: 管理评论数据的 ViewModel。
代码逻辑

初始化: 创建 PostCommentPopView 实例时，传入帖子 ID，并初始化 UI 和数据。
获取评论: 调用 viewModel.fetchComments 方法获取指定帖子的评论列表，并更新 UI。
添加评论: 用户输入评论内容后，点击发送按钮，调用 viewModel.fetcAddComment 方法将评论提交到服务器，并更新 UI。
删除评论: 用户长按评论单元格，调用 viewModel.fetcDeleteComment 方法删除评论，并更新 UI。
UI 更新: 使用 BehaviorRelay 和 RxSwift 实现数据绑定，当 viewModel.commentList 发生变化时，自动更新 UI。
关键点

响应式编程: 使用 RxSwift 的 BehaviorRelay 来管理数据，实现实时更新。
数据驱动 UI: UI 的展示和更新完全由数据驱动。
模块化: 将视图和数据逻辑分离，提高代码的可维护性。
异步操作: 使用 async/await 处理网络请求，提高代码的可读性。
总结

 这段代码实现了一个功能完整的评论弹出视图，可以展示帖子评论、添加评论和删除评论。它采用了现代的 iOS 开发技术，如 RxSwift、SwiftUI 等，使得代码结构清晰，易于维护。*/
