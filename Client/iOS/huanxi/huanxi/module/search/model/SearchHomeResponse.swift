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
