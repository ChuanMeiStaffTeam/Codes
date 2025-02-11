//
//  PostDetailViewModel.swift
//  huanxi
//
//  Created by rslz on 2025/1/21.
//

import Foundation
import RxRelay


extension PostDetailViewModel {
    enum CellType: Equatable {
        case skeleton
        case userItem([UserInfoModel])
        case postItem(PostModel)
        case recommend(MainModel)
        case empty
        case error

        // 计算属性 items，根据不同的 case 返回关联值
        var item: PostModel? {
            switch self {
            case .postItem(let post):
                return post
            default:
                return nil
            }
        }
        
        static func == (lhs: CellType, rhs: CellType) -> Bool {
            switch (lhs, rhs) {
            case (.skeleton, .skeleton), (.empty, .empty), (.error, .error):
                return true
            case let (.postItem(leftItem), .postItem(rightItem)):
                return leftItem == rightItem
            case let (.userItem(leftItem), .userItem(rightItem)):
                return leftItem == rightItem
            default:
                return false
            }
        }
    }
}

class PostDetailViewModel {

    let dataList = BehaviorRelay<[CellType]>(value: Array(repeating: .skeleton, count: 3))

    func requestLikePost(
        params: [String: Any], completion: @escaping (Bool) -> Void
    ) {
        NetworkManager.shared.postRequest(
            path: "postImage/likePost",
            parameters: params,
            responseType: String.self
        ) { success, message, data in
            if success {

            } else {
                HUDHelper.showToast(message)
            }
            completion(success)
        }
    }

    func requestCancelLikePost(
        params: [String: Any], completion: @escaping (Bool) -> Void
    ) {
        NetworkManager.shared.postRequest(
            path: "postImage/cancelLikePost",
            parameters: params,
            responseType: String.self
        ) { success, message, data in
            if success {

            } else {
                HUDHelper.showToast(message)
            }

            completion(success)
        }
    }

    
    func fetchCollectPost(_ params: [String: Any]) async -> Bool {
        await withCheckedContinuation { continuation in
            NetworkManager.shared.postRequest(
                path: "postImage/collectPost",
                parameters: params,
                responseType: String.self
            ) { success, message, data in
                if success {
                } else {
                    HUDHelper.showToast(message)
                }
                continuation.resume(returning: success)
            }
        }
    }
    
    func fetchCancelCollectPost(_ params: [String: Any]) async -> Bool {
        await withCheckedContinuation { continuation in
            NetworkManager.shared.deleteRequest(
                path: "postImage/cancelCollectPost",
                parameters: params,
                responseType: String.self
            ) { success, message, data in
                if success {
                } else {
                    HUDHelper.showToast(message)
                }
                continuation.resume(returning: success)
            }
        }
    }
    
    
    func requestDeletePost(
        params: [String: Any], indexPath: IndexPath?, completion: @escaping (Bool) -> Void
    ) {
        NetworkManager.shared.deleteRequest(
            path: "postImage/deletePost",
            parameters: params,
            responseType: String.self
        ) { [weak self] success, message, data in
            if success {
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                 guard let indexPath = indexPath else { return }
                    var currentData = self.dataList.value
                    currentData.remove(at: indexPath.row)
                    self.dataList.accept(currentData)
                }
            } else {
                HUDHelper.showToast(message)
            }
            completion(success)
        }
    }
    

    // MARK: - 点赞逻辑
    func fetchLikeAction(_ data: PostModel, indexPath: IndexPath?) {
        if !data.liked {
            requestLikePost(params: ["postId" : data.postId ?? 0]) { [weak self] success in
                guard let `self` = self else { return }
                if success {
                    let index = indexPath?.row ?? 0
                    self.updateLikeStatus(at: index, liked: true, indexPath: indexPath)
                 }
            }
        } else {
            requestCancelLikePost(params: ["postId" : data.postId ?? 0]) { [weak self] success in
                guard let `self` = self else { return }
                if success {
                    let index = indexPath?.row ?? 0
                    self.updateLikeStatus(at: index, liked: false, indexPath: indexPath)
                }
            }
        }
    }
    func updateLikeStatus(at index: Int, liked: Bool, indexPath: IndexPath?) {
        var currentPosts = dataList.value
        var post = currentPosts[index].item ?? PostModel(liked: false)

        post.liked = liked
        post.likesCount = liked ? (post.likesCount ?? 0) + 1 : (post.likesCount ?? 0) - 1

        currentPosts[index] = .postItem(post)
        dataList.accept(currentPosts)
    }
    
    // MARK: - 收藏逻辑
    func fetchCollectAction(_ data: PostModel, indexPath: IndexPath?, complete:((Bool)->Void)?) {
        let params = ["postId" : data.postId ?? 0]
        Task {
            let success = !(data.favorite ?? false) ? await fetchCollectPost(params) : await fetchCancelCollectPost(params)
            if success {
                let index = indexPath?.row ?? 0
                DispatchQueue.main.async {
                    self.updateCollectStatus(at: index, favorite: !(data.favorite ?? false), indexPath: indexPath)
                }
                NotificationCenter.default.post(
                    name: .collectNotification,
                    object: nil,
                    userInfo: nil
                )
                complete?(!(data.favorite ?? false))
             }
        }
    }
    func updateCollectStatus(at index: Int, favorite: Bool, indexPath: IndexPath?) {
        var currentPosts = dataList.value
        var post = currentPosts[index].item ?? PostModel(liked: false)
        post.favorite = favorite
        currentPosts[index] = .postItem(post)
        dataList.accept(currentPosts)
    }
    
    func hiddenFollow(indexPath: IndexPath?) {
//        self.isNoRecommend = true
        DispatchQueue.main.async {
         guard let indexPath = indexPath else { return }
            var currentData = self.dataList.value
            currentData.remove(at: indexPath.row)
            self.dataList.accept(currentData)
        }
    }
    
    // MARK: - 标记举报
    func requestMarkPost(
        params: [String: Any], indexPath: IndexPath?, completion: @escaping (Bool) -> Void
    ) {
        NetworkManager.shared.postRequest(
            path: "reports/mark",
            parameters: params,
            responseType: String.self
        ) { [weak self] success, message, data in
            if success {
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                 guard let indexPath = indexPath else { return }
                    var currentData = self.dataList.value
                    currentData.remove(at: indexPath.row)
                    self.dataList.accept(currentData)
                }
            } else {
                HUDHelper.showToast(message)
            }
            completion(success)
        }
    }
    func hiddenReport(indexPath: IndexPath?) {
        DispatchQueue.main.async {
         guard let indexPath = indexPath else { return }
            var currentData = self.dataList.value
            currentData.remove(at: indexPath.row)
            self.dataList.accept(currentData)
        }
    }

}

/*代码分析：帖子详情页视图模型
 核心功能

 这段代码定义了一个名为 PostDetailViewModel 的视图模型类，主要负责管理帖子详情页的数据和业务逻辑。它与 PostDetailViewController 视图控制器协同工作，实现帖子详情页的功能。

 关键点

 CellType 枚举: 定义了表格视图中可能出现的各种 Cell 类型，包括骨架屏、帖子内容、用户信息、推荐用户等。
 dataList 属性: 使用 BehaviorRelay 存储 Cell 类型数组，作为 UITableView 的数据源。
 网络请求: 提供了 requestLikePost, requestCancelLikePost, fetchCollectPost, fetchCancelCollectPost 等方法，用于处理点赞、取消点赞、收藏、取消收藏等网络请求。
 数据更新: 在网络请求成功后，更新 dataList 中的数据，触发 UI 刷新。
 业务逻辑: 处理点赞、收藏、删除帖子等业务逻辑。
 代码结构

 CellType 枚举: 定义了不同类型的 Cell，方便管理和区分。
 dataList 属性: 使用 BehaviorRelay 实现响应式编程，当数据发生变化时，自动更新 UI。
 网络请求方法: 封装了网络请求的逻辑，并使用 NetworkManager 进行网络请求。
 数据更新方法: 更新 dataList 中的数据，触发 UI 刷新。
 业务逻辑方法: 实现点赞、收藏、删除等功能的具体逻辑。
 代码亮点

 MVVM 模式: 清晰地分离了视图和数据逻辑，提高了代码的可维护性。
 响应式编程: 使用 RxSwift 实现数据绑定和状态管理，简化了代码。
 模块化: 将不同的功能封装成独立的方法，提高代码的可复用性。
 潜在改进

 错误处理: 可以添加更详细的错误处理，例如显示具体的错误信息。
 异步编程: 可以使用 async/await 进一步优化异步操作。
 单元测试: 可以编写单元测试来保证代码的正确性。
 数据缓存: 可以缓存一些数据，减少网络请求。*/
