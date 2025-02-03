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



/*代码功能
 
 这段代码定义了一个名为 CommentViewModel 的类，用于管理评论相关的业务逻辑，主要包括：

 获取评论列表: 通过 fetchComments(_ postId: Int) 方法向服务器请求指定帖子的评论列表，并更新 commentList 属性。
 添加评论: 通过 fetcAddComment(_ postId: Int, parentCommentId: Int?, content: String) 方法向服务器发送请求，添加一条新的评论，并更新 commentList 属性。
 删除评论: 通过 fetcDeleteComment(_ postId: Int, parentCommentId: Int?, commentId: Int, indexPath: IndexPath?) 方法向服务器发送请求，删除一条评论，并更新 commentList 属性。
 代码结构

 CellType 枚举: 定义了列表中可能出现的单元格类型，包括：

 .skeleton: 骨架屏，用于加载时显示占位符。
 .commentItem(CommentModel): 评论单元格，包含具体的评论数据。
 .empty: 空状态，表示没有评论。
 .error: 错误状态，表示加载评论失败。
 HomeViewModel 类:

 skeletonData: 一个包含骨架屏单元格的数组，用于初始化列表。
 dataSource: 存储实际的评论数据，类型为 [CellType] 数组。
 commentList: 一个 BehaviorRelay 对象，用于发布评论列表数据的变化，并通知订阅者（如 UI 组件）。
 fetchComments(_ postId: Int): 异步获取评论列表的方法。
 fetcAddComment(_ postId: Int, parentCommentId: Int?, content: String): 异步添加评论的方法。
 fetcDeleteComment(_ postId: Int, parentCommentId: Int?, commentId: Int, indexPath: IndexPath?): 异步删除评论的方法。
 代码逻辑

 获取评论列表:

 fetchComments 方法首先将 commentList 设为骨架屏状态，然后向服务器发送请求获取评论列表数据。
 如果请求成功，将获取到的 CommentModel 数组转换为 CellType 数组，并更新 dataSource 和 commentList。
 如果请求失败，将 commentList 设为空数组，并显示错误提示。
 添加评论:

 fetcAddComment 方法向服务器发送请求，添加一条新的评论。
 如果请求成功，创建一个新的 CommentModel 对象，将其添加到 dataSource 的开头，并更新 commentList。
 如果请求失败，显示错误提示。
 删除评论:

 fetcDeleteComment 方法向服务器发送请求，删除指定的评论。
 如果请求成功，从 dataSource 中移除对应的单元格，并更新 commentList。
 如果请求失败，显示错误提示。
 关键点

 BehaviorRelay: 使用 BehaviorRelay 来管理评论列表数据，使得数据变化能够实时反映到 UI 上。
 异步操作: 使用 async/await 处理网络请求，提高代码的可读性和可维护性。
 数据转换: 将 CommentModel 转换为 CellType 数组，方便在 UI 层进行展示。
 错误处理: 对网络请求的成功与失败进行了基本的处理，并在失败时显示错误提示。
 进一步分析

 NetworkManager: 该类应该是用于封装网络请求的工具类，负责发送网络请求并处理响应。
 HUDHelper: 该类可能用于显示提示信息或加载指示器。
 LoginManager: 该类可能用于获取当前登录用户的用户信息。
 UI 适配: 可以在 CellType 中添加更多的状态，例如加载中状态、加载失败状态等，以更好地适配不同的 UI 需求。
 错误处理: 可以进一步完善错误处理机制，例如记录错误日志、显示更详细的错误信息等。
 总结

 这段代码定义了一个 CommentViewModel 类，用于管理评论相关的业务逻辑，包括获取评论列表、添加评论和删除评论。该类使用了 BehaviorRelay、async/await 等技术，并考虑了基本的错误处理，提高了代码的可读性和可维护性。

*/
