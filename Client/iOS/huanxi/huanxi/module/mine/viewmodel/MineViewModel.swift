//
//  MineViewModel.swift
//  huanxi
//
//  Created by rslz on 2024/12/5.
//

import UIKit
import RxRelay

fileprivate let skeletonData: [MineViewModel.CellType] = Array(repeating: .skeleton, count: 18)

class MineViewModel {
    
    let dataList = BehaviorRelay<[MineViewModel.CellType]>(value: [])
    
    let followList = BehaviorRelay<[MineViewModel.CellType]>(value: [])

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
    
    func requestPostList(type: MineViewModel.ListType, userId: String, completion: @escaping (Bool) -> Void) {
        self.dataList.accept(skeletonData)
        NetworkManager.shared.postRequest(
            path: type == .publish ? "postImage/getPostByUserId" : "postImage/getFavoritePostByUserId",
            parameters: ["userId" : userId],
            responseType: [PostModel].self
        ) { [weak self] success, message, data in
            guard let `self` = self else { return }
            if success {
                let cellItems: [MineViewModel.CellType] = (data ?? []).map { MineViewModel.CellType.postItem($0) }
                self.dataList.accept(cellItems)
            } else {
                self.dataList.accept([MineViewModel.CellType.error])
                HUDHelper.showToast(message)
            }
            completion(success)
        }
    }
    
    
    func fetchFollowsList(_ userId: Int) async -> Bool {
        await withCheckedContinuation { continuation in
            self.followList.accept(skeletonData)
            NetworkManager.shared.postRequest(
                path: "follows/getfollowlist",
                parameters: ["userId" : userId],
                responseType: FollowResponseModel.self
            ) { success, message, data in
                if success {
                    let userItems: [CellType] = (data?.followsList ?? []).map { CellType.userItem($0) }
                    DispatchQueue.main.async {
                        self.followList.accept(userItems)
                    }
                } else {
                    self.followList.accept([])
                    HUDHelper.showToast(message)
                }
                continuation.resume(returning: success)
            }
        }
    }
    
    func fetchFanslist(_ userId: Int) async -> Bool {
        await withCheckedContinuation { continuation in
            self.followList.accept(skeletonData)
            NetworkManager.shared.postRequest(
                path: "follows/getfanslist",
                parameters: ["userId" : userId],
                responseType: FollowResponseModel.self
            ) { success, message, data in
                if success {
                    let userItems: [CellType] = (data?.fansList ?? []).map { CellType.userItem($0) }
                    DispatchQueue.main.async {
                        self.followList.accept(userItems)
                    }
                } else {
                    self.followList.accept([])
                    HUDHelper.showToast(message)
                }
                continuation.resume(returning: success)
            }
        }
    }
}

extension MineViewModel {
    
    enum ListType: Int {
        /// 1-发布
        case publish = 0
        /// 2-收藏
        case collect = 1

        var value: String {
            switch self {
            case .publish:
                return "发布"
            case .collect:
                return "收藏"
            }
        }
    }
    
    enum CellType: Equatable {
        case skeleton
        case postItem(PostModel)
        case userItem(UserInfoModel)
        case empty
        case error

        static func == (lhs: CellType, rhs: CellType) -> Bool {
            switch (lhs, rhs) {
            case (.skeleton, .skeleton), (.empty, .empty), (.error, .error):
                return true
            case let (.postItem(leftItem), .postItem(rightItem)):
                return leftItem == rightItem
            default:
                return false
            }
        }
    }
    
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
