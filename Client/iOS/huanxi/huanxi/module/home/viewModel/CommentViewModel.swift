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
            NetworkManager.shared.getRequest(
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
                    comment.text = content
                    let currentTimestampInMilliseconds = Date().timeIntervalSince1970
                    comment.create_time = Int(currentTimestampInMilliseconds)
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
    
    func fetcDeleteComment(_ postId: Int, parentCommentId: Int?, commentId: Int) async -> Bool {
        await withCheckedContinuation { continuation in
            NetworkManager.shared.postRequest(
                path: "comment/deleteComment",
                parameters: ["postId" : postId,
                             "parentCommentId" : parentCommentId ?? 0,
                             "commentId" : commentId],
                responseType: String.self
            ) { success, message, data in
                if success {
//                    self.dataSource.insert(.commentItem(comment), at: 0)
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
    
}



