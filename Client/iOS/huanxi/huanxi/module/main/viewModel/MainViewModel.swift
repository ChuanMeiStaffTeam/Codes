//
//  MainViewModel.swift
//  huanxi
//
//  Created by jack on 2024/2/28.
//

import Foundation

class MainViewModel {

    var dataList: [Any] = []
    var postsList: [PostModel] = []
    var userList: [UserInfoModel] = []

    //mock
    var mainList: [MainModel] = []


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
            path: "postImage/queryHomePosts",
            parameters: nil,
            responseType: PostsResponse.self
        ) { [weak self] success, message, data in
            guard let `self` = self else { return }
            if success {
                self.dataList = []
                self.postsList = data?.list ?? []
                self.userList = data?.users ?? []
                self.dataList.append(self.userList)
                self.dataList.append(contentsOf: self.postsList)
            } else {
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
