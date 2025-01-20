//
//  SearchViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit

class SearchViewController: BaseViewController {
    private let searchHeaderView = SearchHeaderView()
    private let searchTagsView = SearchTagsView()
    private let waterfallView = WaterfallCollectionView()
    private let nav = NavigationController(rootViewController: SearchSugViewController())

    private lazy var emptyView: CCEmptyView = {
        let emptyView = CCEmptyView()
        return emptyView
    }()
    
    private let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        sh_prefersNavigationBarHidden = true
        setupUI()
        bindUI()
        refrehData()
    }

    func setupUI() {
        searchHeaderView.didClickViewCallBack = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.nav.modalPresentationStyle = .overFullScreen
                self.present(self.nav, animated: false)
            }
        }
        view.addSubview(searchHeaderView)
        searchHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.sy_navigationFullHeight)
        }
        
        searchTagsView.didSelectedItemCallBack = { [weak self] text in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                let vc = SearchTagViewController()
                vc.title = text
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }
        view.addSubview(searchTagsView)
        searchTagsView.snp.makeConstraints { make in
            make.top.equalTo(searchHeaderView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }

        waterfallView.didSelectItemBlock = { [weak self] post in
            guard let `self` = self else { return }
            let vc = PostDetailViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.postItem = post
            self.navigationController?.pushViewController(vc, animated: true)
        }
        view.addSubview(waterfallView)
        waterfallView.snp.makeConstraints { make in
            make.top.equalTo(searchTagsView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(UIDevice.sy_tabBarFullHeight)
        }
    }
    
    func bindUI() {
        self.viewModel.postsList
            .subscribe(onNext: { [weak self] cellTypes in
                guard let `self` = self else { return }
                self.waterfallView.items = cellTypes
            })
            .disposed(by: disposeBag)
        
        self.viewModel.postTagList
            .subscribe(onNext: { [weak self] tags in
                guard let `self` = self else { return }
                self.searchTagsView.reloadData(tags)
            })
            .disposed(by: disposeBag)
    }

}

extension SearchViewController {
    private func refrehData() {
        viewModel.requestDefaultSearchPosts {result in
        }
    }
}
