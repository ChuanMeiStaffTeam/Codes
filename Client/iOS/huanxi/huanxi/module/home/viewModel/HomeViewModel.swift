//
//  HomeViewModel.swift
//  huanxi
//
//  Created by jack on 2024/2/28.
//

import Foundation
import RxRelay
import BUAdSDK

extension HomeViewModel {
    enum ReloadType {
        case reloads    // 刷新
        case loadMore   // 加载更多
    }
    
    enum CellType: Equatable {
        case skeleton
        case userItem([UserInfoModel])
        case postItem(PostModel)
        case recommend(MainModel)
        case ad(BUNativeAd)
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

    @UserDefaultWrapper<Bool>(key: UserDefaultKeys.homeNoRecommend, defaultValue: false)
    private var isNoRecommend: Bool
    private var pageNo = 1
    private var pageSize = 10
    private var dataSource: [CellType] = []

    let dataList = BehaviorRelay<[CellType]>(value: Array(repeating: .skeleton, count: 3))
    let hasMoreRelay = BehaviorRelay<Bool>(value: true)

    required init() {
        self.isNoRecommend = false
    }


    func requestHomePosts(reloadType: ReloadType = .reloads, completion: ((Bool) -> Void)? = nil) {
        
        pageNo = reloadType == .reloads ? 1 : pageNo
        
        let params = [
            "page": pageNo,
            "limit": pageSize
        ]
        
        NetworkManager.shared.postRequest(
            path: LoginManager.shared.isLogin() ? "postImage/queryHomePosts" : "postImage/visitorGetPost",
            parameters: params,
            responseType: PostsResponse.self
        ) { [weak self] success, message, data in
            guard let `self` = self else { return }
            if success {
                let postsItems: [CellType] = (data?.list ?? []).map { CellType.postItem($0) }
                let userItems: [UserInfoModel] = data?.users ?? []

                switch reloadType {
                case .reloads:
                    self.dataSource = []
                    self.dataSource.append(CellType.userItem(Array(userItems.prefix(6))))
                    self.dataSource.append(contentsOf: postsItems)
                    if !isNoRecommend {
                        let recommend = MainModel(type: "recommend", users: Array(userItems.suffix(6)))
                        if self.dataSource.count > 5 {
                            self.dataSource.insert(CellType.recommend(recommend), at: 4)
                        }
                    }
                    self.dataList.accept(self.dataSource)
                    notifyHasMoreStatus(postsItems)
                    if postsItems.count >= 10 { self.pageNo += 1 }
                case .loadMore:
                    self.dataSource.append(contentsOf: postsItems)
                    self.dataList.accept(self.dataSource)
                    notifyHasMoreStatus(postsItems)
                    if postsItems.count >= 10 { self.pageNo += 1 }
                }
            } else {
                self.dataList.accept([HomeViewModel.CellType.error])
                HUDHelper.showToast(message)
            }
            completion?(success)
        }
    }
    
    /// 是否还有更多数据
    private func notifyHasMoreStatus(_ items: [CellType]) {
        if self.dataSource.isEmpty {
            self.hasMoreRelay.accept(true)
        } else {
            self.hasMoreRelay.accept(items.count >= 10)
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

    // MARK: - 标记/举报
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

/*代码功能
 
 这段代码定义了一个名为 HomeViewModel 的类，用于管理应用程序首页的数据和业务逻辑。它主要负责：

 数据管理: 使用 BehaviorRelay 管理首页的数据，并通过 CellType 枚举来区分不同类型的单元格。
 网络请求: 通过 requestHomePosts 等函数向服务器发送请求，获取首页数据。
 UI 更新: 当数据发生变化时，更新 dataList 属性，从而触发 UI 的更新。
 用户交互: 处理用户的点赞、收藏等操作。
 代码结构

 CellType 枚举: 定义了首页列表中不同类型的单元格，包括骨架屏、用户列表、帖子、推荐、空状态和错误状态等。
 HomeViewModel 类:
 isNoRecommend: 一个布尔值，用于控制是否显示推荐内容。
 dataList: 一个 BehaviorRelay 对象，用于存储首页列表的数据。
 configData: 初始化一些模拟数据，用于开发测试。
 requestHomePosts: 发送网络请求获取首页数据，并更新 dataList。
 requestLikePost, requestCancelLikePost 等函数：处理点赞、收藏等用户交互。
 其他函数：用于处理删除帖子、隐藏推荐等操作。
 代码逻辑

 数据初始化: 在 configData 函数中，初始化了一些模拟数据，用于开发测试。
 网络请求: requestHomePosts 函数向服务器发送请求，获取首页数据。根据返回的数据，更新 dataList。
 UI 更新: dataList 的变化会触发 UI 的更新，因为 dataList 是一个 BehaviorRelay 对象，它会自动通知订阅者。
 用户交互: 当用户进行点赞、收藏等操作时，会触发相应的函数，发送网络请求，更新本地数据，并刷新 UI。
 关键点

 BehaviorRelay: 使用 BehaviorRelay 来管理数据，使得数据变化能够实时反映到 UI 上。
 CellType 枚举: 使用 CellType 枚举来区分不同类型的单元格，方便管理和渲染。
 网络请求: 使用 NetworkManager 发送网络请求，获取数据。
 数据处理: 将网络请求返回的数据转换为 CellType 数组，以便填充到 dataList 中。
 异步操作: 使用 async/await 处理异步操作，例如网络请求。
 总结

 这段代码实现了一个首页视图模型，主要负责管理首页的数据和业务逻辑。它使用了 RxSwift 的 BehaviorRelay 来实现响应式编程，使 UI 能够实时更新。同时，它还处理了网络请求、用户交互等功能。

*/
