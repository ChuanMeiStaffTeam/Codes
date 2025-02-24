//
//  SquareViewModel.swift
//  huanxi
//
//  Created by rslz on 2025/1/20.
//

import Foundation
import RxRelay

extension SquareViewModel {
    
    enum ReloadType {
        case reloads    // 刷新
        case loadMore   // 加载更多
    }
    
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

class SquareViewModel {

    private var pageNo = 1
    private var pageSize = 10
    private var dataSource: [CellType] = []

    let dataList = BehaviorRelay<[CellType]>(value: Array(repeating: .skeleton, count: 3))
    let hasMoreRelay = BehaviorRelay<Bool>(value: true)

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
                let list: [CellType] = (data?.list ?? []).map { CellType.postItem($0) }
                let postsItems = Array(list.reversed())
                switch reloadType {
                case .reloads:
                    self.dataSource = []
                    self.dataSource.append(contentsOf: postsItems)
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
                self.dataList.accept([CellType.error])
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
//        self.isNoRecommend = true
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

/*代码功能：

这段代码主要实现了一个用户注册的视图控制器。它负责收集用户的注册信息（账号、昵称、密码等），并向服务器发送注册请求。

主要功能点：

UI布局: 使用 SnapKit 对各个 UI 元素（如文本输入框、按钮等）进行布局，使其在不同屏幕尺寸下都能保持良好的显示效果。
数据校验: 在提交注册信息之前，会对用户输入的账号、昵称、密码等进行基本的校验，确保输入的有效性。
网络请求: 通过 NetworkManager.shared.postRequest 发送注册请求到服务器，并将服务器返回的结果进行处理。
用户交互: 提供关闭按钮、文本输入框、按钮等交互元素，方便用户进行操作。
代码结构：

类名: RegisterViewController，表示这是一个用于注册的视图控制器。
属性:
closeBtn: 关闭按钮。
accountTF, nickNameTF, pwdTF, repwdTF: 用于输入账号、昵称、密码的文本框。
其他一些用于布局和状态管理的属性。
方法:
viewDidLoad: 在视图加载时，进行 UI 布局和绑定事件。
setupView: 初始化 UI 元素并设置约束。
closeAction: 关闭视图控制器。
registerAction: 处理注册按钮点击事件，验证输入信息并发送网络请求。
代码逻辑:

用户输入: 用户在文本框中输入账号、昵称和密码。
校验: 点击注册按钮时，系统会校验输入信息的合法性，例如密码是否一致等。
网络请求: 如果校验通过，则向服务器发送注册请求。
处理响应: 根据服务器返回的结果，显示相应的提示信息，如注册成功或失败。
潜在改进:

密码强度校验: 可以增加密码强度校验，要求密码包含数字、字母和特殊字符等。
用户协议: 可以增加用户协议勾选框，要求用户同意协议才能注册。
验证码: 可以增加验证码功能，提高安全性。
加载指示: 在发送网络请求时，可以显示加载指示器。
错误处理: 可以对网络请求错误进行更详细的处理，并提示用户。
UI优化: 可以对 UI 进行优化，使其更加美观和用户友好。*/
