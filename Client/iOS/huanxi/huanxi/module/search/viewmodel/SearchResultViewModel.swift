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
