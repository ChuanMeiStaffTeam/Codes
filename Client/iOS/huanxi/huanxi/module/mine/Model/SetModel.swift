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

/*
1.SetModel 结构体

用途: 该结构体用于表示设置界面中的一个选项。
属性:
title: String 类型，表示该选项的标题。
subTitle: String 类型，表示该选项的副标题，可选，默认为空字符串。
hasArrow: Bool 类型，表示该选项是否具有箭头图标，默认为 true，表示有箭头图标。
type: Int 类型，表示该选项的类型，用于区分不同类型的设置项。
2.AvatarResponse 结构体

用途: 该结构体用于表示获取用户头像的 API 响应结果。
属性:
avatar: String? 类型，表示用户头像的 URL 地址，为可选类型，表示可能没有头像。*/
