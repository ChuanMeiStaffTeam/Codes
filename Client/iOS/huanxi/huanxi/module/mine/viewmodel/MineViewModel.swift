//
//  MineViewModel.swift
//  huanxi
//
//  Created by rslz on 2024/12/5.
//

import UIKit

class MineViewModel {
    
    func uploadAvatar(_ image: UIImage) async -> Bool {
        await withCheckedContinuation { continuation in
            NetworkManager.shared.uploadSingleImage(path: "userinfo/updateAvatar",
                                                    parameters: [:],
                                                    image: image,
                                                    responseType: AvatarResponse.self) { success, message, data in
                if success {
                } else {
                    HUDHelper.showToast(message)
                }
                continuation.resume(returning: success)
            }
        }
    }
    
    
    
    
}

extension MineViewModel {
    enum ProfileType: Int {
        case name
        case account
        case webSite
        case bio
        
        var title: String {
            switch self {
            case .name:
                return "名字"
            case .account:
                return "欢喜号"
            case .webSite:
                return "主页地址"
            case .bio:
                return "个性签名"
            }
        }
        
        var limit: Int {
            switch self {
            case .name:
                return 12
            case .account:
                return 12
            case .webSite:
                return 24
            case .bio:
                return 24
            }
        }
        
        var key: String {
            switch self {
            case .name:
                return "fullName"
            case .account:
                return "username"
            case .webSite:
                return "websiteUrl"
            case .bio:
                return "bio"
            }
        }
    }
}
