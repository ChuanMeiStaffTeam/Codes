//
//  UserInfoModel.swift
//  huanxi
//
//  Created by jack on 2024/7/25.
//

import Foundation

struct LoginModel: Codable {
    
    let token: String
    let userinfo: UserInfoModel
    
}

struct UserInfoModel: Codable {
    
    let username: String?
    let phoneNumber: String?
    let userId: Int?
    let loginAttempts: Int?
    
//    "username" : "003",
//    "phoneNumber" : null,
//    "address" : null,
//    "followingCount" : null,
//    "lastLoginAt" : "2024-08-07 09:55:28 #æ¥ææ ¼å¼å",
//    "websiteUrl" : null,
//    "country" : null,
//    "lockoutTime" : null,
//    "dateOfBirth" : null,
//    "postCount" : null,
//    "loginAttempts" : 0,
//    "twitterUrl" : null,
//    "city" : null,
//    "bio" : null,
//    "createdAt" : "2024-07-29 10:51:05 #æ¥ææ ¼å¼å",
//    "facebookUrl" : null,
//    "state" : null,
//    "updatedAt" : "2024-07-29 10:51:14 #æ¥ææ ¼å¼å",
//    "gender" : null,
//    "email" : null,
//    "favoriteCount" : null,
//    "postalCode" : null,
//    "profilePictureUrl" : null,
//    "privacySettings" : null,
//    "accountLocked" : false,
//    "followerCount" : null,
//    "fullName" : "003",
//    "userId" : 26
    
}
