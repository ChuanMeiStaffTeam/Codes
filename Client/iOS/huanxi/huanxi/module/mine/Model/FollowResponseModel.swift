//
//  FollowResponseModel.swift
//  huanxi
//
//  Created by rslz on 2025/1/20.
//

import Foundation

struct FollowResponseModel: Codable {
    let followsList: [UserInfoModel]?
    let fansList: [UserInfoModel]?
}


/*这段代码定义了一个名为 FollowResponseModel 的结构体，用于表示关注和粉丝列表的响应模型。

结构体属性:

followsList: 这是一个可选的 [UserInfoModel] 数组，表示当前用户所关注的用户列表。
fansList: 这是一个可选的 [UserInfoModel] 数组，表示当前用户的粉丝列表。
用途:

该结构体通常用于处理与用户关注和粉丝相关的数据。例如：

在获取关注列表或粉丝列表的网络请求中，服务器返回的 JSON 数据可以被解码为 FollowResponseModel 对象。
然后，可以通过访问 followsList 和 fansList 属性来获取关注用户和粉丝的用户信息。
UserInfoModel 结构体（在其他地方定义）应该包含用户的详细信息，如用户名、头像、个人简介等。*/
