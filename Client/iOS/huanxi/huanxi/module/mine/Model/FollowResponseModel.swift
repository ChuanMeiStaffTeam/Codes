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
