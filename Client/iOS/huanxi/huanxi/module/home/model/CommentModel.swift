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
    var sysComment: SysCommentModel?
    var profilePictureUrl: String?
    var fullName: String?
}

struct SysCommentModel: Codable {
    var commentId: Int?
    var postId: Int?
    var userId: Int?
    var commentText: String?
    var parentCommentId: Int?
    var isActive: Int?
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


/*代码功能

这段代码定义了三个 Swift 结构体，用于表示评论相关的模型。这些模型主要用于在应用程序中存储和处理评论数据。

CommentResponseModel: 这个结构体表示从服务器获取的评论列表的响应数据。它包含一个 comments 数组，这个数组中存储了多个 CommentModel 对象，也就是具体的评论信息。
CommentModel: 这个结构体表示一条评论。它包含了评论的作者信息（头像、用户名）、评论内容、创建时间等。
SysCommentModel: 这个结构体包含了更详细的评论系统信息，比如评论 ID、帖子 ID、用户 ID、创建时间、更新时间等。它通常被嵌套在 CommentModel 中，用于存储系统生成的评论数据。
代码详解

Codable 协议: 这三个结构体都遵守了 Codable 协议，这意味着它们可以自动进行 JSON 编码和解码。这在网络请求和数据存储时非常方便，可以将 Swift 对象与 JSON 数据进行相互转换。
属性定义: 每个结构体中定义了多个属性，这些属性对应着评论的各个字段。例如，CommentModel 中的 profilePictureUrl 属性表示评论者的头像 URL，sysComment 属性则包含了更详细的评论信息。
嵌套结构: CommentModel 中嵌套了 SysCommentModel 结构体，这种设计可以将评论的用户信息和系统生成的评论信息进行分离，提高代码的可读性和维护性。
代码作用

这段代码在应用程序中扮演着重要的角色，主要用于以下方面：

数据模型: 定义了评论数据的结构，为后续的业务逻辑提供了数据基础。
网络请求: 在与服务器进行数据交互时，可以将 CommentResponseModel 作为响应数据类型，方便解析 JSON 数据并填充到对应的模型中。
界面展示: 可以将 CommentModel 中的数据绑定到 UI 控件上，展示评论内容。

总结

这段代码通过定义三个结构体，清晰地描述了评论数据的结构，为后续的业务逻辑提供了良好的基础。通过 Codable 协议，可以方便地将 JSON 数据映射到 Swift 对象，从而实现数据的序列化和反序列化。

可能存在的改进

自定义解码: 对于一些复杂的数据类型，可以自定义解码逻辑，以满足特定的需求。
错误处理: 可以添加错误处理机制，例如在解码失败时抛出异常或返回默认值。
性能优化: 对于大量的数据，可以考虑使用性能更高的 JSON 解析库。*/
