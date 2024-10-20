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
    
    let username: String?
    let phoneNumber: String?
    let userId: Int?
    let loginAttempts: Int?
    let profilePictureUrl: String?
    let fullName: String?
    let email: String?
    let bio: String?
    let websiteUrl: String?
    
    let address: String?
    var followingCount: Int? = 0
    let lastLoginAt: String?
    let country: String?
    let lockoutTime: String?
    let dateOfBirth: String?
    var postCount: Int? = 0
    let twitterUrl: String?
    let city: String?
    let createdAt: String?
    let facebookUrl: String?
    let state: String?
    let updatedAt: String?
    let gender: String?
    var favoriteCount: Int? = 0
    let postalCode: String?
    let privacySettings: String?
    var followerCount: Int? = 0
    
}
