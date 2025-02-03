//
//  PostModel.swift
//  huanxi
//
//  Created by jack on 2024/8/13.
//

import Foundation

struct PostModel: Codable, Equatable {
    var user: UserInfoModel?
    var images : [PostImage]?
    var likedUsers: [UserInfoModel]?
    var caption: String?
    var comments: [CommentModel]?
    var liked : Bool
    var likesCount: Int?
    var favorite : Bool? = false
    var bookmarked: Bool?
    var postTime: Date?
    var location: String?
    var createdAt: String?
    var postId: Int?
    var userId: Int?

    var captionHeight: CGFloat?
    var imageHeight: CGFloat?

    static func == (lhs: PostModel, rhs: PostModel) -> Bool {
        return lhs.postId == rhs.postId
    }
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


/*代码功能

这段代码定义了两个结构体：PostModel 和 PostImage，用于表示社交媒体平台上的帖子信息。

PostModel 结构体

属性:

user: 表示发布该帖子的用户信息。
images: 帖子包含的图片列表。
likedUsers: 点赞该帖子的用户列表。
caption: 帖子的文字描述。
comments: 帖子收到的评论列表。
liked: 当前用户是否已点赞该帖子。
likesCount: 该帖子的点赞数量。
favorite: 当前用户是否已收藏该帖子。
bookmarked: 是否已收藏（与 favorite 可能有相似含义）。
postTime: 帖子发布时间。
location: 帖子发布的地点。
createdAt: 帖子的创建时间（字符串格式）。
postId: 帖子的唯一标识符。
userId: 发布该帖子的用户 ID。
captionHeight: 帖子文字描述的计算高度。
imageHeight: 帖子图片的高度。
Equatable 协议: 实现了 Equatable 协议，使得可以比较两个 PostModel 对象是否相等。两个 PostModel 对象相等，当且仅当它们的 postId 相同。

PostImage 结构体

属性:
createdAt: 图片的创建时间。
filterUsed: 应用于图片的滤镜名称。
imageHeight: 图片的高度。
imageWidth: 图片的宽度。
imageId: 图片的唯一标识符。
imageUrl: 图片的 URL。
postId: 该图片所属的帖子 ID。
updatedAt: 图片的更新时间。
代码分析

Codable 协议: 两个结构体都遵守了 Codable 协议，这意味着它们可以自动进行 JSON 编码和解码，方便与服务器进行数据交互。
属性定义: 每个结构体定义了多个属性，用于描述帖子的各个方面，包括用户信息、图片信息、评论信息、点赞信息等。
Equatable 协议: PostModel 实现了 Equatable 协议，可以方便地比较两个帖子对象是否相同，例如用于判断列表中是否包含某个帖子。
可能的使用场景

网络请求: 从服务器获取帖子数据时，将 JSON 数据解码为 PostModel 对象。
数据存储: 将 PostModel 对象存储到本地，例如存储到数据库或缓存中。
界面展示: 将 PostModel 对象中的数据绑定到 UI 控件上，展示帖子内容。
列表处理: 使用 Equatable 协议来判断列表中是否包含某个帖子，或者对帖子列表进行去重操作。
改进建议

考虑使用更明确的属性名: 比如将 liked 改为 isLiked，提高代码的可读性。
添加注释: 为每个属性添加注释，解释其含义和用途。
使用更严格的类型检查: 对于某些属性，例如 likesCount，可以使用 Int? 而不是 Int，以避免潜在的错误。
 考虑使用 Swift 的枚举类型: 对于某些属性，例如 filterUsed，可以使用枚举类型来表示可能的值，提高代码的可读性和安全性。*/
