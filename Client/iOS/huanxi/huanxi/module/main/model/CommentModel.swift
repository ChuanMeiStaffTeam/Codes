//
//  CommentModel.swift
//  huanxi
//
//  Created by rslz on 2024/11/6.
//

import Foundation

struct CommentModel: Codable  {
    var user: UserInfoModel
    var content: String
    var date: Date
    var likes: Int
}
