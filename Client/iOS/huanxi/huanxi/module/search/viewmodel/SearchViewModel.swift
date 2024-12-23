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
