//
//  PostModel.swift
//  huanxi
//
//  Created by jack on 2024/8/13.
//

import Foundation

struct PostModel: Codable {
    var user: UserInfoModel?
    var images : [PostImage]?
    var likedUsers: [UserInfoModel]?
    var caption: String?
    var comments: [CommentModel]?
    var liked : Bool
    var bookmarked: Bool?
    var postTime: Date?
    var likesCount: Int?
    var location: String?
    var createdAt: String?
}

struct PostImage: Codable {
    var createdAt: String?
    var filterUsed: String?
    var imageHeight: String?
    var imageWidth: String?
    var imageId: Int?
    var imageUrl: String?
    var postId: Int?
    var updatedAt: String?
}
