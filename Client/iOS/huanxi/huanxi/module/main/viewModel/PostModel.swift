//
//  PostModel.swift
//  huanxi
//
//  Created by jack on 2024/8/13.
//

import Foundation

struct PostModel: Codable {

    struct image: Codable {
        let createdAt: String?
        let filterUsed: String?
        let imageHeight: String?
        let imageWidth: String?
        let imageId: Int?
        let imageUrl: String?
        let postId: Int?
        let updatedAt: String?
    }
    
    let caption: String?
    let commentsCount: Int?
    let createdAt: String?
    let deleted: Bool?
    let favoriteCount: Int?
    let images: [image]?
    let imagesUrl: String?
    let likesCount: Int?
    let location: String?
    let postId: Int?
//    let public: Bool?
    let tags: String?
    let updatedAt: String?
    let userId: Int?
    let visibility: String?
    var liked: Bool? = false
    var favorite: Bool? = false
    
    let user: UserInfoModel?

}
