//
//  UserInfoModel.swift
//  huanxi
//
//  Created by jack on 2024/7/25.
//

import Foundation

struct UserInfoResponse: Codable {
    let user: UserInfoModel?
}


struct LoginModel: Codable {
    var isFirst: Bool?
    let token: String
    let userinfo: UserInfoModel
}

struct UpdateUserModel: Codable {
    var reported: Bool?
    let user: UserInfoModel
}

struct UserInfoModel: Codable, Equatable{
    
    var username: String?
    var fullName: String?
    var nickname: String?
    var phoneNumber: String?
    var userId: Int?
    var loginAttempts: Int?
    var profilePictureUrl: String?
    var email: String?
    var bio: String?
    var websiteUrl: String?
    var address: String?
    var avatar: String?
    var followingCount: Int? = 0
    var lastLoginAt: String?
    var country: String?
    var lockoutTime: String?
    var dateOfBirth: String?
    var postCount: Int? = 0
    var twitterUrl: String?
    var city: String?
    var createdAt: String?
    var facebookUrl: String?
    var state: String?
    var updatedAt: String?
    var gender: String?
    var favoriteCount: Int? = 0
    var postalCode: String?
    var privacySettings: String?
    var followerCount: Int? = 0
    
}

/*代码分析：UserInfoModel
代码结构与功能

这段代码主要定义了三个结构体，用来表示用户相关的数据：

UserInfoResponse: 表示从服务器获取的用户数据响应。它包含一个可选的 user 属性，类型为 UserInfoModel，表示用户信息。
LoginModel: 表示登录成功后的响应数据。包含用户是否为首次登录、登录 token 和用户信息。
UserInfoModel: 是核心结构体，详细定义了用户信息，包括用户名、昵称、邮箱、头像、社交媒体链接、登录时间、创建时间等。
关键点

Codable协议: 这三个结构体都遵循 Codable 协议，这意味着它们可以轻松地与 JSON 数据进行编码和解码。这在网络请求中非常有用，可以方便地将 JSON 数据映射到 Swift 对象。
可选属性: 许多属性被定义为可选类型（使用问号），这表示这些属性可能为空。这在实际应用中非常常见，因为服务器返回的数据可能不完整。
Equatable协议: UserInfoModel 遵循 Equatable 协议，这意味着可以比较两个 UserInfoModel 对象是否相等。
用途

这段代码通常用于以下场景：

用户注册: 在用户注册时，将用户输入的信息保存到 UserInfoModel 中，并发送给服务器进行注册。
用户登录: 在用户登录成功后，服务器返回的用户信息会映射到 LoginModel 中，然后将 UserInfoModel 保存到本地，以便后续使用。
用户信息更新: 当用户修改个人信息时，将更新后的信息发送给服务器，服务器返回的响应数据会映射到 UpdateUserModel 中。
用户信息展示: 在用户个人中心等页面展示用户信息时，会从本地或服务器获取 UserInfoModel 数据，并将其绑定到 UI 控件上。*/
