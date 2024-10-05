//
//  MainViewModel.swift
//  huanxi
//
//  Created by jack on 2024/2/28.
//

import Foundation

class MainViewModel {
    
    var mainList: [MainModel] = []
    var data: PostsResponse?
    
    required init() {
        configData()
    }
    
    func configData() {
        
        let u = MainUserModel.init(title: "用户名", icon: "")
        
        let user = MainModel(type: "user", users: [u, u, u, u,])
        let content = MainModel(type: "content", users: [])
        let recommend = MainModel(type: "recommend", users: [])
	
        mainList = [user, content, content, content, recommend, content, content, content, content]
    }
    
    func requestHomePosts(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.getRequest(urlStr: "postImage/queryHomePosts",
                                         parameters: nil,
                                         responseType: PostsResponse.self) { success, message, data in
            if success {
                self.data = data
            } else {
                HUDHelper.showToast(message)
            }
            completion(success)
        }
    }
    
    func requestLikePost(params: [String: Any], completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.postRequest(urlStr: "postImage/likePost",
                                         parameters: params,
                                         responseType: String.self) { success, message, data in
            if success {

            }
            HUDHelper.showToast(message)
            completion(success)
        }
    }
    
    func requestCancelLikePost(params: [String: Any], completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.postRequest(urlStr: "postImage/cancelLikePost",
                                         parameters: params,
                                         responseType: String.self) { success, message, data in
            if success {

            }
            HUDHelper.showToast(message)
            completion(success)
        }
    }
    
    func requestCollectPost(params: [String: Any], completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.postRequest(urlStr: "postImage/collectPost",
                                         parameters: params,
                                         responseType: String.self) { success, message, data in
            if success {

            }
            HUDHelper.showToast(message)
            completion(success)
        }
    }
    
    func requestCancelCollectPost(params: [String: Any], completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.deleteRequest(urlStr: "postImage/cancelCollectPost",
                                         parameters: params,
                                         responseType: String.self) { success, message, data in
            if success {

            }
            HUDHelper.showToast(message)
            completion(success)
        }
    }
    
    
}
