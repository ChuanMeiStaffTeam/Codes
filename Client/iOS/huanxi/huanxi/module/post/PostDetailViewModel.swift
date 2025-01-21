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

}

