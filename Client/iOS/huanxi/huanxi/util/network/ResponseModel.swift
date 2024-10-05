//
//  ResponseModel.swift
//  huanxi
//
//  Created by jack on 2024/8/13.
//

import Foundation

struct PostsResponse: Codable {
    let list: [PostModel]?
    let users: [UserInfoModel]?
}


struct ImageResponse: Codable {
    let list: [String]?
}
