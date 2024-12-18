//
//  SearchViewModel.swift
//  huanxi
//
//  Created by rslz on 2024/12/18.
//

import RxCocoa
import RxRelay
import RxSwift

class SearchViewModel: BaseViewModel {
    var postsList: [PostModel] = []

}


extension SearchViewModel {
    func requestDefaultSearchPosts(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.postRequest(
            path: "postImage/defaultSearchPosts",
            parameters: nil,
            responseType: [PostModel].self
        ) { [weak self] success, message, data in
            guard let `self` = self else { return }
            if success {
                let items = (data ?? []).map { var model = $0
                    model.imageHeight = CGFloat.random(in: 100...250)
                    return model
                }
                postsList = items
            } else {
                HUDHelper.showToast(message)
            }
            completion(success)
        }

    }
}
