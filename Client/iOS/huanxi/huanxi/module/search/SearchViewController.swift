//
//  SearchViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit

class SearchViewController: BaseViewController {
    private let searchHeaderView = SearchHeaderView()
    private let waterfallView = WaterfallCollectionView()

    private let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        sh_prefersNavigationBarHidden = true
        setupUI()
        refrehData()
    }

    func setupUI() {
        searchHeaderView.didClickViewCallBack = { [weak self] in
            guard let self = self else { return }
            let vc = SearchSugViewController()
            let nav = NavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overFullScreen
            self.present(nav, animated: false)
        }
        view.addSubview(searchHeaderView)
        searchHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.sy_navigationFullHeight)
        }

        waterfallView.didSelectItemBlock = { [weak self] _ in
            let vc = SearchDetailListViewController()
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        view.addSubview(waterfallView)
        waterfallView.snp.makeConstraints { make in
            make.top.equalTo(searchHeaderView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(UIDevice.sy_tabBarFullHeight)
        }
    }
}

extension SearchViewController {
    private func refrehData() {
        viewModel.requestDefaultSearchPosts { [weak self] result in
            guard let self = self else { return }
            if result {
                self.waterfallView.items = self.viewModel.postsList
            }
        }
    }
}
