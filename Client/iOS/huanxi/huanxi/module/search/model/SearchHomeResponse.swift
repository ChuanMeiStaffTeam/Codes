//
//  SearchHomeResponse.swift
//  huanxi
//
//  Created by rslz on 2024/12/21.
//


struct SearchHomeResponse: Codable {
    let postTagList: [String]?
    let list: [PostModel]?
}


/*结构体定义:
 
 定义了一个名为 SearchHomeResponse 的结构体，该结构体符合 Codable 协议。
 Codable 协议是 Swift 中用于支持编码和解码的协议，使得该结构体可以方便地与 JSON 等数据格式进行转换。
 属性:

 postTagList:
 一个可选的字符串数组 [String]?。
 可能是与搜索查询相关的推荐标签或主题词的列表。
 list:
 一个可选的 PostModel 对象数组 [PostModel]?。
 可能是与搜索查询匹配的帖子列表。 PostModel 结构体（未在该代码片段中定义）应该包含有关每个帖子的详细信息，例如标题、内容、作者、图片等。
 功能

 该结构体用于表示从服务器端获取的搜索结果数据。
 通过 Codable 协议，可以方便地将服务器返回的 JSON 数据解码为 SearchHomeResponse 对象，以便在应用程序中使用。*/
