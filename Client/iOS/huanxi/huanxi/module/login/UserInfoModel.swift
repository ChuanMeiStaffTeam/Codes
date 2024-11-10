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
    
    let token: String
    let userinfo: UserInfoModel
    
}

struct UserInfoModel: Codable {
    
    var username: String?
    var nickname: String?
    var phoneNumber: String?
    var userId: Int?
    var loginAttempts: Int?
    var profilePictureUrl: String?
    var fullName: String?
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
