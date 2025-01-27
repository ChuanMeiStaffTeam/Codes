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

/*解释:
 
 PostsResponse:

 包含两个属性：
 list: 一个可选的 PostModel 数组，表示一组帖子。
 users: 一个可选的 UserInfoModel 数组，表示一组用户信息，可能与帖子相关联。
 PostModel:

 表示单个帖子，包含以下属性：
 id: 帖子的唯一标识符。
 title: 帖子的标题。
 content: 帖子的内容。
 userId: 创建帖子的用户的 ID。
 您可以根据实际需求添加其他属性，例如发布时间、评论数等。
 UserInfoModel:

 表示用户信息，包含以下属性：
 id: 用户的唯一标识符。
 name: 用户的姓名。
 avatar: 用户的头像 URL。
 您可以根据实际需求添加其他属性，例如邮箱、性别等。
 ImageResponse:

 表示一组图片 URL，包含以下属性：
 list: 一个可选的字符串数组，每个字符串代表一张图片的 URL。
 注意:

 这些结构体只是示例，您需要根据实际的 API 返回数据来调整属性和类型。
 确保属性名与服务器返回的 JSON 数据中的字段名一致，否则解码可能会失败。
 如果服务器返回的数据包含嵌套的结构体，则需要相应地定义嵌套的结构体。*/
