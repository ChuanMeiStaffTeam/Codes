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

/*代码功能:
 
 这段代码定义了一个名为 MineViewModel 的类，用于处理用户个人中心页面的数据和逻辑。

 主要功能点:

 数据模型:

 CellType 枚举：定义了不同类型的 cell，包括骨架屏、帖子、用户、空状态和错误状态。
 ListType 枚举：定义了两种列表类型：发布和收藏。
 ProfileType 枚举：定义了用户个人资料中可编辑的字段类型，如姓名、账号、主页地址、个性签名。
 数据源:

 dataList：一个 BehaviorRelay，用于存储和发布帖子列表或收藏列表的数据。
 followList：一个 BehaviorRelay，用于存储和发布关注者或粉丝列表的数据。
 网络请求:

 requestPostList：根据 ListType 发送网络请求，获取用户发布的帖子或收藏的帖子列表。
 fetchFollowsList：发送网络请求，获取用户关注的用户列表。
 fetchFanslist：发送网络请求，获取用户的粉丝列表。
 uploadAvatar：发送网络请求，上传用户头像。
 其他方法:

 bindUI：用于绑定 UI 控件与数据源的交互。
 refrehData：用于刷新数据。
 setEmptyOrNetErrorView：用于显示空状态或网络错误视图。
 代码结构:

 MineViewModel 类：包含了数据源、网络请求、数据处理、UI 逻辑等。
 CellType 枚举：定义了 cell 的类型。
 ListType 枚举：定义了列表的类型。
 ProfileType 枚举：定义了用户个人资料的字段类型。
 代码逻辑:

 初始化 MineViewModel 时，会初始化 dataList 和 followList 变量。
 requestPostList 方法用于获取用户发布的帖子或收藏的帖子列表，并更新 dataList 变量。
 fetchFollowsList 方法用于获取用户关注的用户列表，并更新 followList 变量。
 fetchFanslist 方法用于获取用户的粉丝列表，并更新 followList 变量。
 uploadAvatar 方法用于上传用户头像。
 bindUI 方法用于绑定 UI 控件与数据源的交互，例如将 dataList 绑定到 UITableView 的数据源，以便更新界面。
 refrehData 方法用于刷新数据，通常用于下拉刷新。
 setEmptyOrNetErrorView 方法用于显示空状态或网络错误视图，例如当没有数据或网络请求失败时。
 潜在改进:

 错误处理: 可以进一步完善错误处理，例如针对不同类型的网络错误显示不同的错误提示。
 数据缓存: 可以考虑缓存数据，以提高性能和减少网络请求。
 分页加载: 可以实现分页加载，以提高用户体验。
 单元测试: 可以编写单元测试来验证代码的正确性和稳定性。*/
