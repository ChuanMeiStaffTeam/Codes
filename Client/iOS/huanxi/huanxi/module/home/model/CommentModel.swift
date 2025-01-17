//
//  CommentModel.swift
//  huanxi
//
//  Created by rslz on 2024/11/6.
//

import Foundation

struct CommentResponseModel: Codable {
    let comments: [CommentModel]?
}

struct CommentModel: Codable {
    var commentId: Int?
    var postId: Int?
    var userId: Int?
    var commentText: String?
    var parentCommentId: Int?
    var isActive: Int?
    var user: UserInfoModel?
    var content: String?
    var date: Date?
    var likes: Int?
    var cid: String?
    var status: Int?
    var text: String?
    var digg_count: Int?
    var createdAt: String?
    var updatedAt: String?
    var reply_id: String?
    var aweme_id: String?
    var user_digged: Int?
    var user_type: String?
    var visitor: VisitorModel?

//    var isTemp: Bool = false
    var taskId: Int?
}
