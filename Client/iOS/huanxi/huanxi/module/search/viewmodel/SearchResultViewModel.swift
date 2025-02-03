//
//  SearchResultViewModel.swift
//  huanxi
//
//  Created by rslz on 2024/12/23.
//

import RxCocoa
import RxRelay
import RxSwift

fileprivate let skeletonData: [SearchViewModel.CellType] = Array(repeating: .skeleton, count: 18)

class SearchResultViewModel: BaseViewModel {
    let postTagList = BehaviorRelay<[String]>(value: [])
    let searchUesrs = BehaviorRelay<[SearchViewModel.CellType]>(value: [])
    let searchPosts = BehaviorRelay<[SearchViewModel.CellType]>(value: [])
    let postsList = BehaviorRelay<[SearchViewModel.CellType]>(value: [])
    let tagPostsList = BehaviorRelay<[SearchViewModel.CellType]>(value: [])
}


extension SearchResultViewModel {
    func requestDefaultSearchPosts(completion: @escaping (Bool) -> Void) {
        self.postsList.accept(Array(repeating: .skeleton, count: 12))
        NetworkManager.shared.postRequest(
            path: "postImage/defaultSearchPosts",
            parameters: nil,
            responseType: SearchHomeResponse.self
        ) { [weak self] success, message, data in
            guard let `self` = self else { return }
            if success {
                self.postTagList.accept(data?.postTagList ?? [])
                let items = (data?.list ?? []).map { var model = $0
                    model.imageHeight = CGFloat.random(in: 100...250)
                    return model
                }
                let cellItems: [SearchViewModel.CellType] = (items).map { SearchViewModel.CellType.postItem($0) }
                self.postsList.accept(cellItems)
            } else {
                self.postsList.accept([SearchViewModel.CellType.error])
                HUDHelper.showToast(message)
            }
            completion(success)
        }
    }
    
    func requestSearchUser(keyword: String, completion: @escaping (Bool) -> Void) {
        self.searchUesrs.accept(skeletonData)
        NetworkManager.shared.postRequest(
            path: "userinfo/searchUser",
            parameters: ["keyword" : keyword],
            responseType: [UserInfoModel].self
        ) { [weak self] success, message, data in
            guard let `self` = self else { return }
            if success {
                let cellItems: [SearchViewModel.CellType] = (data ?? []).map { SearchViewModel.CellType.userItem($0) }
                self.searchUesrs.accept(cellItems)
            } else {
                self.searchUesrs.accept([SearchViewModel.CellType.error])
//                HUDHelper.showToast(message)
            }
            completion(success)
        }
    }
    
    func requestSearchPost(keyword: String, completion: @escaping (Bool) -> Void) {
        self.searchPosts.accept(skeletonData)
        NetworkManager.shared.postRequest(
            path: "postImage/searchPosts",
            parameters: ["keyword" : keyword],
            responseType: SearchHomeResponse.self
        ) { [weak self] success, message, data in
            guard let `self` = self else { return }
            if success {
                let cellItems: [SearchViewModel.CellType] = (data?.list ?? []).map { SearchViewModel.CellType.postItem($0) }
                self.searchPosts.accept(cellItems)
            } else {
                self.searchPosts.accept([SearchViewModel.CellType.error])
//                HUDHelper.showToast(message)
            }
            completion(success)
        }
    }
    
    func requestTagPosts(tags: String, completion: @escaping (Bool) -> Void) {
        self.tagPostsList.accept(Array(repeating: .skeleton, count: 18))
        NetworkManager.shared.postRequest(
            path: "postImage/getPostByTag",
            parameters: ["tag" : tags],
            responseType: [PostModel].self
        ) { [weak self] success, message, data in
            guard let `self` = self else { return }
            if success {
                let cellItems: [SearchViewModel.CellType] = (data ?? []).map { SearchViewModel.CellType.postItem($0) }
                self.tagPostsList.accept(cellItems)
            } else {
                self.tagPostsList.accept([SearchViewModel.CellType.error])
                HUDHelper.showToast(message)
            }
            completion(success)
        }
    }
}

///SearchResultType
enum SearchResultType: Int {
    /// 1-热门搜索
    case hotPost = 0
    /// 2-账户
    case account = 1

    var value: String {
        switch self {
        case .hotPost:
            return "热门搜索"
        case .account:
            return "账户"
        }
    }
}


/*代码功能

这段代码定义了一个名为 SearchResultViewModel 的视图模型类，主要用于管理搜索功能相关的数据和逻辑。它负责处理各种类型的搜索请求，并更新 UI 界面上的搜索结果。

核心功能

数据管理:
使用 BehaviorRelay 来管理不同类型的搜索结果的状态：
postTagList: 存储搜索结果中推荐的标签列表。
searchUesrs: 存储搜索结果中匹配的用户列表。
searchPosts: 存储搜索结果中匹配的帖子列表。
postsList: 存储默认搜索帖子列表。
tagPostsList: 存储根据标签搜索到的帖子列表。
数据获取:
提供了多个方法来从网络获取数据：
requestDefaultSearchPosts()：获取默认的搜索帖子列表。
requestSearchUser(keyword:): 根据关键字搜索用户。
requestSearchPost(keyword:): 根据关键字搜索帖子。
requestTagPosts(tags:): 根据标签搜索帖子。
骨架屏:
使用 skeletonData 来显示占位符单元格，在网络请求期间给用户提供视觉反馈。
错误处理:
当网络请求失败时，更新相应的数据源为 error 单元格类型，并显示错误提示。
搜索结果类型:
引入了 SearchResultType 枚举来区分不同的搜索结果类型（热门搜索、账户等）。
代码结构

SearchResultViewModel 类:
属性:
postTagList: 存储推荐标签列表的 BehaviorRelay。
searchUesrs: 存储搜索用户列表的 BehaviorRelay。
searchPosts: 存储搜索帖子列表的 BehaviorRelay。
postsList: 存储默认搜索帖子列表的 BehaviorRelay。
tagPostsList: 存储标签帖子列表的 BehaviorRelay。
方法:
各个 request 方法用于发起网络请求，获取对应的数据，并更新相应的 BehaviorRelay。
CellType 枚举:
定义了不同类型的单元格，用于表示不同的数据类型（骨架屏、帖子、用户、空状态、错误状态）。
SearchResultType 枚举:
定义了不同的搜索结果类型，用于区分不同的搜索场景。
代码亮点

使用 RxSwift: 利用 RxSwift 的响应式编程特性，方便地管理数据流和 UI 更新。
数据驱动: 通过 BehaviorRelay 将数据与 UI 绑定，实现数据变化时 UI 的自动更新。
网络请求: 封装了网络请求逻辑，方便调用。
错误处理: 提供了基本的错误处理机制。
模块化: 将不同的搜索类型封装成不同的方法，提高代码的可维护性。
总结

 SearchResultViewModel 是一个非常典型的视图模型，它负责管理搜索功能中的数据和业务逻辑。通过将数据和视图逻辑分离，提高了代码的可测试性和可维护性。*/
