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

    let container = UIView.init()
    let textView = CommentTextView()
    let drawerView = DrawerView()
    

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
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0)
        tableView.separatorStyle = .none
        tableView.register(CommentListCell.self)
        return tableView
    }()
    
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
            make.left.right.equalToSuperview()
            make.bottom.equalTo(CGFloat.bottomSafeAreaHeight)
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
                    return cell
                case .commentItem(let item):
                    let cell: CommentListCell = tableView.dequeueReusableCell(forIndexPath: IndexPath(row: index, section: 0))
                    cell.initData(comment: item)
                    return cell
                default:
                    let cell: UITableViewCell = UITableViewCell().then({ view in
                        view.backgroundColor = .clear
                    })
                    return cell
                }
            }
            .disposed(by: disposeBag)
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
            self.removeFromSuperview()
            self.textView.dismiss()
        }
    }
}
