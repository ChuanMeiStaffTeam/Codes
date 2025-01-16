//
//  VisitorModel.swift
//  huanxi
//
//  Created by rslz on 2024/11/11.
//

import Foundation

struct VisitorModel: Codable {
    var uid: String?
    var udid: String?
    var avatar: String?
    var avatar_thumbnail: PostImage?
    var avatar_medium: PostImage?
    var avatar_large: PostImage?

    static func write(visitor: VisitorModel) {
        let dic = visitor.toJSON()
        let defaults = UserDefaults.standard
        defaults.set(dic, forKey: "visitor")
        defaults.synchronize()
    }

    static func read() -> VisitorModel {
        let defaults = UserDefaults.standard
        let dic = defaults.object(forKey: "visitor") as? [String: Any]
        let visitor = VisitorModel.from(dictionary: dic)
        return visitor ?? VisitorModel()
    }

    static func formatUDID(udid: String) -> String {

        if udid.count < 8 {
            return "************"
        }
        return udid.substring(location: 0, length: 4) + "****"
            + udid.substring(location: udid.count - 4, length: 4)
    }
}
