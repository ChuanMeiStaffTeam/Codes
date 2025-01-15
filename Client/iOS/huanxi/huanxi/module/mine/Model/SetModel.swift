//
//  SetModel.swift
//  huanxi
//
//  Created by rslz on 2025/1/10.
//

struct SetModel: Codable {
    var title: String
    var subTitle: String = ""
    var hasArrow: Bool = true
    var type: Int = 0
}


struct AvatarResponse: Codable {
    let avatar: String?
}
