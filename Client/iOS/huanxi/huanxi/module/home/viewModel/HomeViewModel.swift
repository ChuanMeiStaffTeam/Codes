//
//  HomeViewModel.swift
//  huanxi
//
//  Created by jack on 2024/2/28.
//

import Foundation
import RxRelay


extension HomeViewModel {
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

class HomeViewModel {

    @UserDefaultWrapper<Bool>(key: "", defaultValue: false)
    var isNoRecommend: Bool

    let dataList = BehaviorRelay<[CellType]>(value: Array(repeating: .skeleton, count: 3))
    //mock
    var mainList: [MainModel] = []
    var postsList: [PostModel] = []

    required init() {
        configData()
    }


    func configData() {
        var u = UserInfoModel()
        u.username = "用户名"
        let user = MainModel(type: "user", users: [u, u, u, u])
        let content = MainModel(type: "content", users: [])
        let recommend = MainModel(type: "recommend", users: [])

        mainList = [
            user, content, content, content, recommend, content, content,
            content, content,
        ]
        
        let icons = ["icon0", "icon1", "icon2", "icon3", "icon4", "icon5", "icon0", "icon1", "icon2", "icon3"]
        let names = ["zixuanooo", "diza", "dnsk", "jack", "rose", "zixuanooo", "diza", "dnsk", "jack", "rose"]
        let contents = ["电话就是不丢吃不都吃不饿还问", "元旦快乐哈哈哈哈哈😄", "评论123哈说的话说的", "i为u你是看见当年参加考试", "建军节说的那就是承诺", "几句话素材你说你刺猬", "u你说的没时间", "OK从事记单词哦接送", "的产业化丢吃呢", "ID农村建设的奶茶"]
        let likesCounts = [65, 86, 35, 69, 22, 56, 77, 89, 81, 23]
        for i in 0..<10 {
            var post = PostModel(liked: false)
            post.postId = i
            var postUser = UserInfoModel()
            postUser.profilePictureUrl = icons[i]
            postUser.fullName = names[i]
            post.user = postUser
            var postImage = PostImage()
            postImage.imageUrl = "list_" + String(i)
            post.images = [postImage]
            post.location = "中国"
            post.likesCount = likesCounts[i]
            post.caption = contents[i]
            post.createdAt = "2024年1月1日"
            postsList.append(post)
        }
    }


    func requestHomePosts(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.getRequest(
            path: LoginManager.shared.isLogin() ? "postImage/queryHomePosts" : "postImage/visitorGetPost",
            parameters: nil,
            responseType: PostsResponse.self
        ) { [weak self] success, message, data in
            guard let `self` = self else { return }
            if success {
                let postsItems: [CellType] = (data?.list ?? []).map { CellType.postItem($0) }
                let userItems: [UserInfoModel] = data?.users ?? []
                var list:[CellType] = []
                list.append(CellType.userItem(Array(userItems.prefix(6))))
                list.append(contentsOf: postsItems)
                if !isNoRecommend {
                    let recommend = MainModel(type: "recommend", users: Array(userItems.suffix(6)))
                    if list.count > 5 {
                        list.insert(CellType.recommend(recommend), at: 4)
                    }
                }
                self.dataList.accept(list)
            } else {
                self.dataList.accept([HomeViewModel.CellType.error])
                HUDHelper.showToast(message)
            }
            completion(success)
        }
    }
    
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
        self.isNoRecommend = true
        DispatchQueue.main.async {
         guard let indexPath = indexPath else { return }
            var currentData = self.dataList.value
            currentData.remove(at: indexPath.row)
            self.dataList.accept(currentData)
        }
    }

}

