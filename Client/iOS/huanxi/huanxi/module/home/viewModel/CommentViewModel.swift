//
//  CommentViewModel.swift
//  huanxi
//
//  Created by rslz on 2025/1/16.
//

import RxRelay

extension CommentViewModel {
    enum CellType {
        case skeleton
        case commentItem(CommentModel)
        case empty
        case error
    }
}

class CommentViewModel {

    private let skeletonData: [CellType] = Array(repeating: .skeleton, count: 7)
    private var dataSource: [CellType] = []

    let commentList = BehaviorRelay<[CellType]>(value: [])
    
    func fetchComments(_ postId: Int) async -> Bool {
        await withCheckedContinuation { continuation in
            self.commentList.accept(skeletonData)
            NetworkManager.shared.postRequest(
                path: "comment/getCommentsByPostId",
                parameters: ["postId" : postId],
                responseType: CommentResponseModel.self
            ) { success, message, data in
                if success {
                    let comentItems: [CellType] = (data?.comments ?? []).map { CellType.commentItem($0) }
                    self.dataSource = comentItems
                    DispatchQueue.main.async {
                        self.commentList.accept(self.dataSource)
                    }
                } else {
                    self.commentList.accept([])
                    HUDHelper.showToast(message)
                }
                continuation.resume(returning: success)
            }
        }
    }
    
    func fetcAddComment(_ postId: Int, parentCommentId: Int?, content: String) async -> Bool {
        await withCheckedContinuation { continuation in
            NetworkManager.shared.postRequest(
                path: "comment/addComment",
                parameters: ["postId" : postId,
                             "parentCommentId" : parentCommentId ?? 0,
                             "commentText" : content],
                responseType: String.self
            ) { success, message, data in
                if success {
                    var comment = CommentModel()
                    var sysComment = SysCommentModel()
                    sysComment.commentText = content
                    sysComment.user_type = "user"
                    let user = LoginManager.shared.getUserInfo()
                    sysComment.userId = user?.userId
                    let fmt = DateFormatter.init()
                    fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let timeStr = fmt.string(from: Date())
                    sysComment.createdAt = timeStr
                    comment.sysComment = sysComment
                    comment.fullName = user?.fullName
                    comment.profilePictureUrl = user?.profilePictureUrl
                    self.dataSource.insert(.commentItem(comment), at: 0)
                    DispatchQueue.main.async {
                        self.commentList.accept(self.dataSource)
                    }
                } else {
                    HUDHelper.showToast(message)
                }
                continuation.resume(returning: success)
            }
        }
    }
    
    func fetcDeleteComment(_ postId: Int, parentCommentId: Int?, commentId: Int, indexPath: IndexPath? ) async -> Bool {
        await withCheckedContinuation { continuation in
            NetworkManager.shared.postRequest(
                path: "comment/deleteComment",
                parameters: ["postId" : postId,
                             "parentCommentId" : parentCommentId ?? 0,
                             "commentId" : commentId],
                responseType: String.self
            ) { success, message, data in
                if success {
                    DispatchQueue.main.async {
                     guard let indexPath = indexPath else { return }
                        self.dataSource.remove(at: indexPath.row)
                        self.commentList.accept(self.dataSource)
                    }
                } else {
                    HUDHelper.showToast(message)
                }
                continuation.resume(returning: success)
            }
        }
    }
    
}



