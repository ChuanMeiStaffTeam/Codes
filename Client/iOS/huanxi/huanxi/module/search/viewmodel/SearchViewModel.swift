//
//  SearchViewModel.swift
//  huanxi
//
//  Created by rslz on 2024/12/18.
//

import RxCocoa
import RxRelay
import RxSwift

fileprivate let skeletonData: [SearchViewModel.CellType] = Array(repeating: .skeleton, count: 7)

class SearchViewModel: BaseViewModel {
    let postTagList = BehaviorRelay<[String]>(value: [])
    let searchUesrs = BehaviorRelay<[CellType]>(value: [])
    let postsList = BehaviorRelay<[CellType]>(value: [])
    let tagPostsList = BehaviorRelay<[CellType]>(value: [])
}


extension SearchViewModel {
    func requestDefaultSearchPosts(completion: @escaping (Bool) -> Void) {
        self.postsList.accept(Array(repeating: .skeleton, count: 12))
        NetworkManager.shared.postRequest(
            path: "postImage/defaultSearchPosts",
            parameters: nil,
            responseType: SearchHomeResponse.self
        ) { [weak self] success, message, data in
            guard let `self` = self else { return }
            if success {
                let filteredPostTagList = (data?.postTagList ?? []).filter { !$0.isEmpty }
                self.postTagList.accept(filteredPostTagList)
                let items = (data?.list ?? []).map { var model = $0
                    model.imageHeight = CGFloat.random(in: 100...250)
                    return model
                }
                let cellItems: [CellType] = (items).map { CellType.postItem($0) }
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
                let cellItems: [CellType] = (data ?? []).map { CellType.userItem($0) }
                self.searchUesrs.accept(cellItems)
            } else {
                self.searchUesrs.accept([SearchViewModel.CellType.error])
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
                let cellItems: [CellType] = (data ?? []).map { CellType.postItem($0) }
                self.tagPostsList.accept(cellItems)
            } else {
                self.tagPostsList.accept([SearchViewModel.CellType.error])
                HUDHelper.showToast(message)
            }
            completion(success)
        }
    }
}

extension SearchViewModel {

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
            case let (.userItem(leftItem), .userItem(rightItem)):
                return leftItem == rightItem
            default:
                return false
            }
        }
    }
}


/*这段代码定义了一个名为 SearchViewModel 的类，用于管理搜索功能相关的数据和逻辑。

主要特点

数据管理:
使用 BehaviorRelay 来管理搜索结果的状态：
postTagList: 存储搜索结果中推荐的标签列表。
searchUesrs: 存储搜索结果中匹配的用户列表。
postsList: 存储搜索结果中匹配的帖子列表。
tagPostsList: 存储根据标签搜索到的帖子列表。
数据获取:
提供了三个方法来从网络获取数据：
requestDefaultSearchPosts()：获取默认的搜索帖子列表并更新 postsList。
requestSearchUser(keyword:): 根据关键字获取匹配的用户列表并更新 searchUesrs。
requestTagPosts(tags:): 根据标签获取匹配的帖子列表并更新 tagPostsList。
骨架屏:
使用 skeletonData 数组来显示占位符单元格，在网络请求期间给用户提供视觉反馈。
错误处理:
当网络请求失败时，更新相应的数据源为 error 单元格类型，并显示错误提示。
代码结构

SearchViewModel 类:

属性:
postTagList: 存储推荐标签列表的 BehaviorRelay。
searchUesrs: 存储搜索用户列表的 BehaviorRelay。
postsList: 存储搜索帖子列表的 BehaviorRelay。
tagPostsList: 存储标签帖子列表的 BehaviorRelay。
方法:
requestDefaultSearchPosts()：获取默认搜索帖子。
requestSearchUser(keyword:): 根据关键字搜索用户。
requestTagPosts(tags:): 根据标签搜索帖子。
CellType 枚举:

定义了不同类型的单元格：
.skeleton：骨架屏单元格。
.postItem：帖子单元格。
.userItem：用户单元格。
.empty：空状态单元格。
.error：错误单元格。
关键概念

RxSwift: 使用 RxSwift 进行响应式编程，方便地观察和处理数据变化。
数据绑定: BehaviorRelay 实现了数据绑定，使得 UI 能够根据视图模型中的数据变化自动更新。
网络请求: 使用 NetworkManager（可能是一个自定义类）来处理网络请求。
错误处理: 通过显示错误单元格和提示消息来处理网络请求错误。
总结

SearchViewModel 类是整个搜索功能的核心，负责管理搜索相关的数据和逻辑。它通过与 UI 层进行数据绑定，实现了数据的实时更新和展示。
 */
