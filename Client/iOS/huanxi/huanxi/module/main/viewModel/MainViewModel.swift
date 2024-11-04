//
//  MainViewModel.swift
//  huanxi
//
//  Created by jack on 2024/2/28.
//

import Foundation

class MainViewModel {

    var mainList: [MainModel] = []
    var postsList: [PostModel] = []

    required init() {
        configData()
    }

    func configData() {

        let u = MainUserModel.init(title: "用户名", icon: "")

        let user = MainModel(type: "user", users: [u, u, u, u])
        let content = MainModel(type: "content", users: [])
        let recommend = MainModel(type: "recommend", users: [])

        mainList = [
            user, content, content, content, recommend, content, content,
            content, content,
        ]
    }

    func requestHomePosts(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.getRequest(
            path: "postImage/queryHomePosts",
            parameters: nil,
            responseType: PostsResponse.self
        ) { success, message, data in
            if success {
                self.postsList = data?.list ?? []
            } else {
                HUDHelper.showToast(message)
            }
            completion(success)
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

                }
                HUDHelper.showToast(message)
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

                }
                HUDHelper.showToast(message)
                completion(success)
            }
        }

        func requestCollectPost(
            params: [String: Any], completion: @escaping (Bool) -> Void
        ) {
            NetworkManager.shared.postRequest(
                path: "postImage/collectPost",
                parameters: params,
                responseType: String.self
            ) { success, message, data in
                if success {

                }
                HUDHelper.showToast(message)
                completion(success)
            }
        }

        func requestCancelCollectPost(
            params: [String: Any], completion: @escaping (Bool) -> Void
        ) {
            NetworkManager.shared.deleteRequest(
                path: "postImage/cancelCollectPost",
                parameters: params,
                responseType: String.self
            ) { success, message, data in
                if success {

                }
                HUDHelper.showToast(message)
                completion(success)
            }
        }

    }
}
